function ret= sp_mode_eq(t,varVec,g,l)

    v=varVec(1);
    m=varVec(2);
    psi_1=varVec(3);
    psi_2=varVec(4);
    ret=zeros(4,1);
    ret(1)=0;
    ret(2)=-m*g/(l+v);
    ret(3)=-1-psi_1*g/(l+v);
    ret(4)=psi_1*g/(m);