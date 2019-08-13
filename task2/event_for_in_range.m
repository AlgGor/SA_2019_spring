function [value,isterminal,direction]=event_for_in_range(t,varVec,M,psi_0,l,u_max)

    v=varVec(1);
    m=varVec(2);
    psi_1=varVec(4);
    psi_2=varVec(5);
    
    tilde_u=nthroot( (psi_2-psi_1*(l+v)/m)/(3*psi_0),3);
    
    if (tilde_u-u_max)*tilde_u>0
        if tilde_u<0
            res=1;
        else
            res=2;   % tilde_u > u_max
        end
    else
        res=0;
    end

    value(1)=  res-1;
    isterminal(1) = 1;
    direction(1) = 0;
    
    value(3)=  res-2;
    isterminal(3) = 1;
    direction(3) = 0;
    
    if m<M
        res=1;
    else
        res=0;
    end
    
    value(5)= res-1;
    isterminal(5) = 1;
    direction(5) = 0;
    
end