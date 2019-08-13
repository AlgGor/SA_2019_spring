function ret= s_star(t,xVec,alpha)

ret=[xVec(2);-(xVec(2)+2*xVec(1)+(xVec(1))*sin((xVec(1))^2)-2*((xVec(1))^2)*cos(xVec(1)))+alpha];