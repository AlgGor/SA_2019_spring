function [value,isterminal,direction]=event_for_out_of_range(t,varVec,M,psi_0,l,u_max)

    v=varVec(1);
    m=varVec(2);
    psi_1=varVec(4);
    psi_2=varVec(5);
    
    tilde_u=nthroot( (psi_2-psi_1*(l+v)/m)/(3*psi_0),3);
    
    if ((tilde_u-u_max)*tilde_u)<=0
        res=1;
    else
        res=0;
    end
    
    value(2)=  res-1;
    isterminal(2) = 1;
    direction(2) = 0;
    
     
    if m<M
        res=1;
    else
        res=0;
    end
    
    value(5)= res-1;
    isterminal(5) = 1;
    direction(5) = 0;
    
end