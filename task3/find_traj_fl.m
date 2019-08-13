function [swTrajMat,xEdgeVec,trajMat]=find_traj_fl(x0Vec,curT,maxT,alpha)

    swTrajMat=x0Vec;
    options= odeset('Events',@my_switch); 
    trajMat=[];
    
    while true
        alpha=-alpha;
        
        x_psiVec0=[x0Vec,1,0];
        [tVecSol,x_psiVecSol,te,x_psieVec,ie] = ode45(@(t,x_psiVec) s_sys(t,x_psiVec,alpha),[curT maxT],x_psiVec0,options);
    
        trajMat=cat(1,trajMat,cat(2,x_psiVecSol(:,1),x_psiVecSol(:,2)));
                
        hold on;
        plot(x_psiVecSol(:,1),x_psiVecSol(:,2),'r');
        hold off;
        
        is_event=size(te);
        if is_event==1
            
            break;
        else
            curT=te(2);
            x0Vec=[x_psieVec(2,1),x_psieVec(2,2)];
        end
        
        swTrajMat=cat(1,swTrajMat,x0Vec);
        
    end
    
    xEdgeVec=[x_psiVecSol(end,1),x_psiVecSol(end,2)];
    

