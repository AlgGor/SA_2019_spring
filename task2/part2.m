function [L_min,tau_Vec_opt]=part2(m0,M,g,u_max,l,T,H) 

    N=20;
    N_t=50;
    
    my_epsilon=2;
    
    alphaVec=linspace(pi/2,3*pi/2,N+2);
    alphaVec=alphaVec(2:N+1);
    betaVec=linspace(0,2*pi,N+1);
    gammaVec=linspace(0,2*pi,N+1);
    
    tau_sw_Vec=[];
    tVec=linspace(0,T,N_t);
    
    v_m_h_psi_1_psi_2_u_Vec_Mat=[];
    L_min=(u_max^5)/5*T;
    
    vVec_opt=[];
    mVec_opt=[];
    hVec_opt=[];
    psi_1_Vec_opt=[];
    psi_2_Vec_opt=[];
    uVec_opt=[];
    tau_Vec_opt=[];
    N_gamma=N;
    
    for alp=1:N
        disp(['step ',num2str(alp),' out of ',num2str(N)]);
        alpha_cur=alphaVec(alp);
        psi_0=cos(alpha_cur);
        
        if sin(alpha_cur)==0
            continue;
        end
        
        for bet=1:N 
            beta_cur=betaVec(bet);
            psi_1_0=sin(alpha_cur)*cos(beta_cur);
            
            if sin(beta_cur)==0
                var_1=-3*m0^4*g^3/l^4;
                if tan(alpha_cur)>=var_1
                     N_gamma=N;
                else
                    continue;
                end
            end
           
            var_1=l*cot(beta_cur)/m0+(3*m0^3*g^3*cot(alpha_cur))/(sin(beta_cur)*l^3);
            
            if var_1<-1
                N_gamma=N;
                gammaVec_new=gammaVec;
            elseif var_1>1
                continue;
            else
                var_2=acos(var_1);
                ind_1=find_prev_time(var_2,gammaVec);
                gammaVec_new=gammaVec(1:ind_1);
                ind_2=find_next_time(2*pi-var_2,gammaVec);
                gammaVec_new=cat(2,gammaVec_new,gammaVec(ind_2:N));
                N_gamma=size(gammaVec_new,2);
            end   
            
            for gam=1:N_gamma
              
                gamma_cur=gammaVec_new(gam);
                
                psi_2_0=sin(alpha_cur)*sin(beta_cur)*cos(gamma_cur);
                psi_3_0=sin(alpha_cur)*sin(beta_cur)*sin(gamma_cur);
               
                t_cur=-T/1000;
                v_cur=0;
                m_cur=m0;
                h_cur=0;
                psi_1_cur=psi_1_0;
                psi_2_cur=psi_2_0;
                psi_3=psi_3_0;
               
                vVec=[];
                mVec=[];
                hVec=[];
                psi_1_Vec=[];
                psi_2_Vec=[];
                uVec=[];
                tau_Vec=[];
                
                tilde_u= nthroot( (psi_2_cur-psi_1_cur*(l+v_cur)/m_cur)/(3*psi_0), 3);
                
                %disp(tilde_u);
                
                if ~isreal(tilde_u)
                    continue;
                end
                
                if min( tilde_u , u_max)<(m0*g/l)
                    %disp('unsolv');
                    %disp(N_gamma);
                    continue;
                end
                
                % определяем из какого режима начинаем
                if tilde_u*(tilde_u-u_max)<0
                    event_cur=2;
                else
                    if tilde_u<0
                        event_cur=1;
                    else
                        event_cur=3;
                    end
                end
                
                while t_cur~=T

                    tspan=tVec(find_next_time(t_cur,tVec):end);
                    
                    if size(tspan,2)==1
                        tspan=tVec(end-1:end);                   
                    end

                    if event_cur==1
                        options_1 = odeset('Events',@(t,varVec) event_for_out_of_range(t,varVec,M,psi_0,l,u_max));
                        [t_sol_Vec,var_sol_Vec,te,~,ie]=ode45(@(t,varVec) p2_eq_out_of_range(t,varVec,l,g,psi_3,0),tspan,[v_cur, m_cur, h_cur, psi_1_cur,psi_2_cur],options_1);
                    elseif event_cur==2
                        options_2 = odeset('Events',@(t,varVec) event_for_in_range(t,varVec,M,psi_0,l,u_max));
                        [t_sol_Vec,var_sol_Vec,te,~,ie]=ode45(@(t,varVec) p2_eq_in_range(t,varVec,l,g,psi_0,psi_3),tspan,[v_cur, m_cur, h_cur, psi_1_cur,psi_2_cur],options_2);
                    elseif event_cur==3
                        options_3 = odeset('Events',@(t,varVec) event_for_out_of_range(t,varVec,M,psi_0,l,u_max));
                        [t_sol_Vec,var_sol_Vec,te,~,ie]=ode45(@(t,varVec) p2_eq_out_of_range(t,varVec,l,g,psi_3,u_max),tspan,[v_cur, m_cur, h_cur, psi_1_cur,psi_2_cur],options_3);
                    end
                    
                    if size(tspan,2)==2
                        var_sol_Vec=cat(1,var_sol_Vec(1,:),var_sol_Vec(end,:));                 
                    end
                    
                    if ~isreal(var_sol_Vec)
                        event_cur=5;
                        break;
                    end
                                        
                    if (ie==5) 
                        %disp('out_of_fuel');
                        event_cur=5;
                        break; 
                    end

                    % запись векторов того, что вышло
                    % и текущее значение всех переменных
                    
                    vVec=cat(1,vVec,var_sol_Vec(:,1)); 
                    mVec=cat(1,mVec,var_sol_Vec(:,2));
                    hVec=cat(1,hVec,var_sol_Vec(:,3));
                    psi_1_Vec=cat(1,psi_1_Vec,var_sol_Vec(:,4));
                    psi_2_Vec=cat(1,psi_2_Vec,var_sol_Vec(:,5));
                    
                    if event_cur==1
                        uVec=cat(1,uVec,0*var_sol_Vec(:,1));
                    elseif event_cur==2
                        u_tilde_Vec=nthroot( (var_sol_Vec(:,5)-var_sol_Vec(:,4).*(l+var_sol_Vec(:,1))./var_sol_Vec(:,2))/(3*psi_0),3) ;
                        if ~isreal(u_tilde_Vec)
                            event_cur=5;
                            break;
                        end
                        uVec=cat(1,uVec,u_tilde_Vec);
                    elseif event_cur==3
                        uVec=cat(1,uVec,u_max+0*var_sol_Vec(:,1));
                    end

                    if size(ie,2)>0  
                        vVec=vVec(1:(end-1));
                        mVec=mVec(1:(end-1));
                        hVec=hVec(1:(end-1));
                        psi_1_Vec=psi_1_Vec(1:(end-1));
                        psi_2_Vec=psi_2_Vec(1:(end-1));
                        uVec=uVec(1:(end-1));
                    end
                    
                    if te>tVec(end-1)
                        break;
                    end
                        
                    if size(te,1)==0
                        t_cur=T;
                    else
                        
                        event_cur=ie;
                        t_cur=tVec(find_prev_time(t_sol_Vec(end),tVec));
                    end

                    v_cur=vVec(end);
                    m_cur=mVec(end);
                    h_cur=hVec(end);
                    psi_1_cur=psi_1_Vec(end);
                    psi_2_cur=psi_2_Vec(end);
                    
                    tau_Vec=cat(2,tau_Vec,t_cur);
                    
                end
                
                if size(uVec,1)==(N_t+1)
                    vVec=vVec(1:(N_t)); mVec=mVec(1:(N_t)); hVec=hVec(1:(N_t));
                    psi_1_Vec=psi_1_Vec(1:(N_t)); psi_2_Vec=psi_2_Vec(1:(N_t));
                    uVec=uVec(1:(N_t));
                elseif size(uVec,1)==(N_t-1)
                    vVec=cat(1,vVec,vVec(N_t-1)); mVec=cat(1,mVec,mVec(N_t-1));  hVec=cat(1,hVec,hVec(N_t-1));
                    psi_1_Vec=cat(1,psi_1_Vec,psi_1_Vec(N_t-1)); psi_2_Vec=cat(1,psi_2_Vec,psi_2_Vec(N_t-1));
                    uVec=cat(1,uVec,uVec(N_t-1));
                end
                
                if event_cur==5
                    continue;
                else
                    
                    
                    if abs(H-hVec(end))>my_epsilon
                        continue;
                    end                   
                    
                    v_m_h_psi_1_psi_2_u_Vec_Mat=cat(2,v_m_h_psi_1_psi_2_u_Vec_Mat,vVec,mVec,hVec,psi_1_Vec,psi_2_Vec,uVec);
                    
                    L_cur=trapz(tVec,(uVec.^4)');
                    if L_cur<L_min
                        vVec_opt= vVec;
                        mVec_opt= mVec;
                        hVec_opt= hVec;
                        psi_1_Vec_opt= psi_1_Vec;
                        psi_2_Vec_opt=psi_2_Vec;
                        uVec_opt=uVec;
                        L_min=L_cur;
                        tau_Vec_opt=tau_Vec;
                    end
                    
                 end
               
            end
        end
    end
        
   
  
   graphics_part_2(tVec,v_m_h_psi_1_psi_2_u_Vec_Mat,vVec_opt,mVec_opt,hVec_opt,psi_1_Vec_opt,psi_2_Vec_opt,uVec_opt)
    

end