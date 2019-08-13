function ret=p2_eq_out_of_range(t,varVec,l,g,psi_3,u_max)

    v=varVec(1);
    m=varVec(2);
    psi_1=varVec(4);
    
    ret=zeros(5,1);
    ret(1)=-g+u_max*(l+v)/m;
    ret(2)=-u_max;
    ret(3)=v;
    ret(4)=-(psi_1*u_max/m+psi_3);
    ret(5)=psi_1*(l+v)*u_max/m^2;

end