function [H_max,tau_sw_Vec]=part1(orig_m0,orig_M,orig_g,orig_u_max,orig_l,orig_T) 
  
    disp('start');

    syms  u_max u_opt T t tilde_t psi_1_0 psi_2 psi_2_0 tilde_m tilde_v const real
    sym_2= sym('2');
    l=sym(orig_l);
    g=sym(orig_g);
    
    psi_1=simplify( (-tilde_m*t-u_max*(t-tilde_t)^sym_2/sym_2+(psi_1_0+tilde_t)*tilde_m)/(tilde_m-u_max*(t-tilde_t)));
    
    v=simplify( ( sym_2*(tilde_m*tilde_v+(l*u_max-g*tilde_m)*(t-tilde_t))+g*u_max*(t-tilde_t)^sym_2)/(sym_2*(tilde_m-u_max*(t-tilde_t))));

    m=tilde_m-u_max*(t-tilde_t);
    
    dot_psi_2=(psi_1*(l+v)*u_max)/m^2;
   
    psi_2=simplify(int(dot_psi_2,t));
    
    const=simplify(solve(subs(psi_2+const-psi_2_0,t,tilde_t),const));
    
    psi_2=simplify(psi_2+const);
    
    % ищем время переключения между u_max и u_opt_ctrl
    % окончание _f появилось, чтобы не испортить исходные формулы
     
    m_f=subs(m,[tilde_t,tilde_m,u_max],['0',sym(orig_m0),sym(orig_u_max)]);
    v_f=simplify(subs(v,[tilde_t,tilde_m,tilde_v,u_max],['0',sym(orig_m0),'0',sym(orig_u_max)]));
    psi_1_f=simplify(subs(psi_1,[tilde_t,tilde_m,tilde_v,u_max],['0',sym(orig_m0),'0',sym(orig_u_max)]));
    psi_2_f=simplify(subs(psi_2,[tilde_t,tilde_m,tilde_v,u_max],['0',sym(orig_m0),'0',sym(orig_u_max)]));


    psi_1_0_f=simplify(solve((psi_1_f+l+v_f)/g,psi_1_0));

    psi_1_f=simplify(subs(psi_1_f,psi_1_0,psi_1_0_f));
    psi_2_f=simplify(subs(psi_2_f,psi_1_0,psi_1_0_f));

    psi_2_0_f=simplify(solve(psi_1_f*(l+v_f)/m_f-psi_2_f,psi_2_0));

    psi_2_f=simplify(subs(psi_2_f,psi_2_0,psi_2_0_f));

    % закончили перепараметризацию
    
    N=20;
    tVec=linspace(0,orig_T,N);

    v_m_psi_1_psi_2_Mat=[];  % матрица со всеми траекториями 
    
    H_max=-(g*orig_T^2)/2-1;   % ниже точно не упадет 
    tau_sw_1=0;
    tau_sw_2=0;
    
    vVec=[];     
    mVec=[];
    psi_1_Vec=[];
    psi_2_Vec=[];
    uVec=[];
       
    vVec_norm=[];            % вектор скоростей для данной траектории
    mVec_norm=[];
    psi_1_Vec_norm=[];
    psi_2_Vec_norm=[];
    uVec_norm=[];
    
    vVec_opt=[];     
    mVec_opt=[];
    psi_1_Vec_opt=[];
    psi_2_Vec_opt=[];
    uVec_opt=[];
    
    
    
    for k=2:N
        
        disp(['step ',num2str(k),' out of ',num2str(N)]);
        
        tau_sw_1=tVec(k);
        tspan=tVec(1:k);
        
        psi_1_0_cur=double(simplify(subs(psi_1_0_f,t,sym(tau_sw_1))));
        psi_2_0_cur=double(simplify(subs(psi_2_0_f,t,sym(tau_sw_1))));
    
        [~,solVec]=ode45(@(t,varVec) norm_mode_eq(t,varVec,g,l,orig_u_max),tspan,[0, orig_m0, psi_1_0_cur,psi_2_0_cur] );
        
        if (k==2) 
            solVec=cat(1,solVec(1,:),solVec(end,:));
        end
        
        vVec_norm=solVec(:,1);
        v_cur_norm=vVec_norm(end);
        mVec_norm=solVec(:,2);
        m_cur_norm=mVec_norm(end);
        psi_1_Vec_norm=solVec(:,3);
        psi_1_cur_norm=psi_1_Vec_norm(end);
        psi_2_Vec_norm=solVec(:,4);
        psi_2_cur_norm=psi_2_Vec_norm(end);
        uVec_norm=orig_u_max+0*vVec_norm;
        
        vVec_sp=[];            % вектор скоростей для данной траектории
        mVec_sp=[];
        psi_1_Vec_sp=[];
        psi_2_Vec_sp=[];
        uVec_sp=[];
    
%         m_cur=double(simplify(subs(m_f,t,sym(tau_sw_1))));
%         v_cur=double(simplify(subs(v_f,t,sym(tau_sw_1))));
%         
%         psi_1_cur=double(simplify(subs(psi_1_f,t,sym(tau_sw_1))));
%         psi_2_cur=double(simplify(subs(psi_2_f,t,sym(tau_sw_1))));
        
        if m_cur_norm>orig_M
            if k~=N
                for r=k:N
                    disp(r);
                    
                    vVec=cat(1,vVec_norm,vVec_sp);
                    mVec=cat(1,mVec_norm,mVec_sp);
                    psi_1_Vec=cat(1,psi_1_Vec_norm,psi_1_Vec_sp);
                    psi_2_Vec=cat(1,psi_2_Vec_norm,psi_2_Vec_sp);
                    uVec=cat(1,uVec_norm,uVec_sp);
                    
                    v_cur=vVec(end);
                    m_cur=mVec(end);
                    psi_1_cur=psi_1_Vec(end);
                    psi_2_cur=psi_2_Vec(end);
                    
%                     v_cur=v_cur_norm;
%                     m_cur=m_cur_norm;
%                     psi_1_cur=psi_1_cur_norm;
%                     psi_2_cur=psi_2_cur_norm;
                    
                    if r~=k
                        
                        %tspan=tVec(k:r);
                        
                        tspan=[tVec(r-1),(tVec(r-1)+tVec(r))/2,tVec(r)];

                        [~,solVec]=ode45(@(t,varVec) sp_mode_eq(t,varVec,g,l),tspan,[v_cur, m_cur, psi_1_cur,psi_2_cur] );
                        
%                         if r==(k+1) %true
%                             solVec=cat(1,solVec(1,:),solVec(end,:));
%                         end
                     
                        solVec=cat(1,solVec(1,:),solVec(end,:));
                        
                        vVec=cat(1,vVec,solVec(2:end,1));
                        v_cur=vVec(end);
                        vVec_sp=cat(1,vVec_sp,solVec(2:end,1));
                        
                        mVec=cat(1,mVec,solVec(2:end,2));
                        m_cur=mVec(end);
                        mVec_sp=cat(1,mVec_sp,solVec(2:end,2));
                        
                        psi_1_Vec=cat(1,psi_1_Vec,solVec(2:end,3));
                        psi_1_cur=psi_1_Vec(end);
                        psi_1_Vec_sp=cat(1,psi_1_Vec_sp,solVec(2:end,3));
                        
                        psi_2_Vec=cat(1,psi_2_Vec,solVec(2:end,4));
                        psi_2_cur=psi_2_Vec(end);
                        psi_2_Vec_sp=cat(1,psi_2_Vec_sp,solVec(2:end,4));
                        
                        u_sp_mode=double(solVec(2:end,2)*g./(l+solVec(2:end,1)));
                        uVec=cat(1,uVec,u_sp_mode);
                        uVec_sp=cat(1,uVec_sp,u_sp_mode);
                                                
                    end
                    
                    if r~=N
                        tspan=tVec(r:N);

                        [~,solVec]=ode45(@(t,varVec) norm_mode_eq(t,varVec,g,l,0),tspan,[v_cur, m_cur, psi_1_cur,psi_2_cur]);

                        if r==(N-1)
                            solVec=cat(1,solVec(1,:),solVec(end,:));
                        end

                        vVec=cat(1,vVec,solVec(2:end,1));
                        mVec=cat(1,mVec,solVec(2:end,2));
                        psi_1_Vec=cat(1,psi_1_Vec,solVec(2:end,3));
                        psi_2_Vec=cat(1,psi_2_Vec,solVec(2:end,4));
                        uVec=cat(1,uVec,0*solVec(2:end,1));

                    end   

                    H_cur= trapz(tVec,vVec');
                    if H_cur>H_max
                        H_max=H_cur;
                        vVec_opt=vVec;     
                        mVec_opt=mVec;
                        psi_1_Vec_opt=psi_1_Vec;
                        psi_2_Vec_opt=psi_2_Vec;
                        u_opt=uVec;
                        tau_sw_1=tVec(k);
                        tau_sw_2=tVec(r);
                    end

                    v_m_psi_1_psi_2_Mat=cat(2, v_m_psi_1_psi_2_Mat,vVec,mVec,psi_1_Vec,psi_2_Vec,uVec);
                    
                    if m_cur<=orig_M
                        break;
                    end
                                            
                end
            else
                
                H_cur= trapz(tVec,vVec_norm');
                %disp( H_cur);

                if H_cur>H_max
                    H_max=H_cur;
                    vVec_opt=vVec_norm;     
                    mVec_opt=mVec_norm;
                    psi_1_Vec_opt=psi_1_Vec_norm;
                    psi_2_Vec_opt=psi_2_Vec_norm;
                    u_opt=uVec_norm;
                    tau_sw_1=tVec(k);
                    tau_sw_2=tVec(k);
                end
                v_m_psi_1_psi_2_Mat=cat(2, v_m_psi_1_psi_2_Mat,vVec_norm,mVec_norm,psi_1_Vec_norm,psi_2_Vec_norm,uVec_norm);
        
            end
        else
            %disp('out of fuel');
            % достраиваем траекторию при u^*=0 
            [vVec_out,mVec_out, psi_1_Vec_out,psi_2_Vec_out]=out_of_fuel(v_cur_norm, m_cur_norm, psi_1_cur_norm,psi_2_cur_norm,g,l,tVec,k,N);
                        
            vVec=cat(1,vVec_norm,vVec_out);
            mVec=cat(1,mVec_norm,mVec_out);
            psi_1_Vec=cat(1,psi_1_Vec_norm,psi_1_Vec_out);
            psi_2_Vec=cat(1,psi_2_Vec_norm,psi_2_Vec_out);
            uVec=cat(1,uVec_norm,0*vVec_out);
            
            v_m_psi_1_psi_2_Mat=cat(2, v_m_psi_1_psi_2_Mat,vVec,mVec,psi_1_Vec,psi_2_Vec,uVec);
            
            H_cur= trapz(tVec,vVec');
            if H_cur>H_max
                H_max=H_cur;
                vVec_opt=vVec;     
                mVec_opt=mVec;
                psi_1_Vec_opt=psi_1_Vec;
                psi_2_Vec_opt=psi_2_Vec;
                u_opt=uVec;
                tau_sw_1=tVec(k);
                tau_sw_2=tVec(k);
            end
            
            break;
        end

    end

   graphics_part_1(tVec,v_m_psi_1_psi_2_Mat,vVec_opt,mVec_opt,psi_1_Vec_opt,psi_2_Vec_opt,u_opt)
    
   if (tau_sw_1-tau_sw_2)<(tVec(1)/2)
       tau_sw_Vec=tau_sw_1;
   else
       tau_sw_Vec=[tau_sw_1,tau_sw_2];
   end

end 
