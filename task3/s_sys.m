function ret= s_sys(t,x_psiVec,alpha)

ret=zeros(4,1);
ret(1)=x_psiVec(2);
ret(2)=-(x_psiVec(2)+2*x_psiVec(1)+(x_psiVec(1))*sin((x_psiVec(1))^2)-2*((x_psiVec(1))^2)*cos(x_psiVec(1)))+alpha;

ret(3)= x_psiVec(4)*(2+sin(x_psiVec(1)^2)+2*x_psiVec(1)^2*cos(x_psiVec(1)^2)-4*x_psiVec(1)*cos(x_psiVec(1))+2*x_psiVec(1)^2*sin(x_psiVec(1)));
ret(4)=-x_psiVec(3)+x_psiVec(4);