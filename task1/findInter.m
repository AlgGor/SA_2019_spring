function [xVec,yVec,degen]= findInter(s,p,q,r)

    solMat=[];
    syms x y;

    for k=1:2

        eqns = [(x+((-1)^(k+1))*s*y)==r, s*((x-p)^2)+(y-q)^2==r];
        vars=[x y];
        [solx,soly]=solve(eqns,vars);

        if ((isreal(solx(1)))&&(isreal(soly(1)))&&(solx(1)>=0)&&((-1)^(k+1)*soly(1)>=0)&&(solx(1)<=r))
            solMat=cat(1,solMat,[solx(1),soly(1)]);
        end
        if ((isreal(solx(2)))&&(isreal(soly(2)))&&(solx(2)>=0)&&((-1)^(k+1)*soly(2)>=0)&&(solx(2)<=r))
            solMat=cat(1,solMat,[solx(2),soly(2)]);
        end

        eqns = [(-x+((-1)^(k+1))*s*y)==r, s*((x-p)^2)+(y-q)^2==r];
        vars=[x y];
        [solx,soly]=solve(eqns,vars);

        if ( (isreal(solx(1)))&&(isreal(soly(1)))&&(solx(1)<=0)&&((-1)^(k+1)*soly(1)>=0)&&(-r<=solx(1)))
            solMat=cat(1,solMat,[solx(1),soly(1)]);
        end
        if ((isreal(solx(2)))&&(isreal(soly(2)))&&(solx(2)<=0)&&((-1)^(k+1)*soly(2)>=0)&&(-r<=solx(2)))
            solMat=cat(1,solMat,[solx(2),soly(2)]);
        end

    end
    
    if size(solMat,1)==0  
        degen=1;
        xVec=[];
        yVec=[];
    else
        degen=0;
        xVec=double(solMat(:,1)');
        yVec=double(solMat(:,2)');
    end

end