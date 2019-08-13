function [psiTime,xOptMat,uOptMat,psiOptMat,solFlag]=findTraj(psiLast,x1,aMat,bMat,fVec,maxTime,nTime,supP,a,b,supX,xv,yv,xInterVec,yInterVec,interType,s,p,q,r,maxX,maxY,xFundMat)

    syms t tau real;
    
    expA=expm(aMat*(t-tau));
      
    expAT=expm((-aMat)'*(t-tau));
    expAT=subs(expAT,tau,maxTime);
       
    timeStep=maxTime/nTime;
    timeVec=fliplr([0,(1:nTime)*timeStep]);
    
    
    curX=x1;
    curU=[0;0];
    solFlag=0;
    xOptMat=zeros(2,nTime);
    uOptMat=zeros(2,nTime);
    psiOptMat=zeros(2,nTime);
    rightSide=zeros(2,nTime);
    
    
    for m=1:(nTime+1)
        curTime=timeVec(m);
        curPsi=double(subs(expAT,t,curTime))*psiLast;
        psiOptMat(:,m)=curPsi;
        [~,curU]=supP((bMat')*curPsi,a,b);
        uOptMat(:,m)=curU;
        expA=subs(expA,t,curTime);
        for k=1:m
            rightSide(:,k)=double(xFundMat(2*m-1:2*m,2*k-1:2*k)*(bMat*(uOptMat(:,k))+fVec));
        end
        rightSide=rightSide(:,1:m);
        curX=double(subs(expA,tau,maxTime))*x1-trapz(fliplr(timeVec(1:k)),rightSide,2);
        
       
        xOptMat(:,m)=curX;
        
        xDistVec=xv-curX(1);
        yDistVec=yv-curX(2);
        dist=min(sqrt(xDistVec.^2+yDistVec.^2));
        
        if ((inpolygon(curX(1),curX(2),xv,yv)==1)||(dist<0.02))
            solFlag=1;
            break
        end
        
        if (inpolygon(curX(1),curX(2),[-maxX,-maxX,maxX,maxX],[-maxY,maxY,maxY,-maxY])==0)
            m=m-1;
            break
        end
    end    
    
%   disp(solFlag);
    xOptMat=xOptMat(:,1:m);
    uOptMat=uOptMat(:,1:m);
    psiOptMat=psiOptMat(:,1:m);
    psiTime=curTime;
    
    
   
    %mist=
   
    
end