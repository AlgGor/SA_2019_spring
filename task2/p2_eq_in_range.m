function ret=p2_eq_in_range(t,varVec,l,g,psi_0,psi_3)

    v=varVec(1);
    m=varVec(2);
    psi_1=varVec(4);
    psi_2=varVec(5);
    
    cur_u=nthroot( (psi_2-psi_1*(l+v)/m)/(3*psi_0),3);
        
    ret=zeros(5,1);
    ret(1)=-g+cur_u*(l+v)/m;
    ret(2)=-cur_u;
    ret(3)=v;
    ret(4)=-(psi_1*cur_u/m+psi_3);
    ret(5)=psi_1*(l+v)*cur_u/m^2;

    
end