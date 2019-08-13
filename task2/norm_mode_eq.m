function ret= norm_mode_eq(t,varVec,g,l,u_max)

    v=varVec(1);
    m=varVec(2);
    psi_1=varVec(3);
    psi_2=varVec(4);
    
    ret=zeros(4,1);
    ret(1)=-g+u_max*(l+v)/m;
    ret(2)=-u_max;
    ret(3)=-1-psi_1*u_max/m;
    ret(4)=psi_1*(l+v)*u_max/m^2;
    
    
end