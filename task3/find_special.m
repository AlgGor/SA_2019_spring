function [solVec,isResilVec]=find_special(xMin,xMax,alpha)
    N=ceil(abs(xMin)+abs(xMax));
    xVec=linspace(xMin,xMax,N);
    solVec=[];
    jacob=@(x) [0,1;2+sin(x^2)+2*x^2*cos(x^2)-4*x*cos(x)+2*x^2*sin(x),1];
    for k=1:N
        [sol,~,exitflag]=fsolve(@(x) my_eq_plus(x,alpha),xVec(k));
        
        if exitflag>0
            solVec=cat(2,solVec,sol);
        end 
        [sol,~,exitflag]=fsolve(@(x) my_eq_minus(x,alpha),xVec(k));
        if exitflag>0
            solVec=cat(2,solVec,sol);
        end
        solVec=fix(solVec*10000)/10000; 
    end    
    
    solVec=unique(solVec);
    %disp(solVec);
    isResilVec=solVec*0;
    
    for l=1:size(solVec,2)
        jacobMat=jacob(solVec(l));
        
        disp(jacobMat);
        [~,lambdaMat,~]=eig(jacobMat);
        disp(lambdaMat);
        if (real(lambdaMat(1))<0) && (real(lambdaMat(4))<0)
            isResilVec(l)=1;
        end
        
    end
    
   disp(solVec);
   disp(isResilVec);