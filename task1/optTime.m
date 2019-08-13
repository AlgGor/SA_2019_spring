function [optTime,xOptMat,uOptMat,psiOptMat,hugeXMat,hugeUMat,hugePsiMat,solFlag]=optTime(s,p,q,r,x1,aMat,bMat,fVec,a,b,maxTime,xOptMat,uOptMat,psiOptMat,hugeXMat,hugeUMat,hugePsiMat,prevOptTime,nL,nTime,impFlag)

    startX=10.0;
    startY=10.0;
    step=0.02;
    x=-startX:step:startX;
    y=-startY:step:startY;
    [xVec,yVec] = meshgrid(x,y);
   
    f0=@(xVec,yVec,s,p,q) max(abs(xVec)+s*abs(yVec),s*((xVec-p).^2)+(yVec-q).^2);
   
    if s<0
       error('Incorrect input!'); 
    end

    zMat=f0(xVec,yVec,s,p,q);
    figure(1);
    surf(xVec,yVec,-zMat);
    [M,~]=contourf(xVec,yVec,-zMat,[-r, -r]);

    if M(2,1)~=(size(M,2)-1)
        if M(2,1)>M(2,2+M(2,1))
            xv=M(1,2:1+M(2,1));
            yv=M(2,2:1+M(2,1));
        else
            xv=M(1,3+M(2,1):size(M,2));
            yv=M(2,3+M(2,1):size(M,2));      
        end 
    else
        xv=M(1,2:size(M,2));
        yv=M(2,2:size(M,2));    
    end
    
    xv=[xv,xv(end)];
    yv=[yv,yv(end)];
        
    in=inpolygon(x1(1),x1(2),xv,yv);

    if in==1
        disp('Solved! We are already in x1');
        optTime=0;
        return; 
    end
    
    interType=30;

    if (s>0)
        if s>1
            reverse=0;
        else
            reverse=1;
            myVec=xVec;
            xVec=yVec;
            yVec=myVec;
        end  

        [xInterVec,yInterVec,degen]=findInter(s,p,q,r);
        if degen==1
            if (r<p+sqrt(r/s))&&(p-sqrt(r/s)<-r)&&(r/s<q+sqrt(r))&&(q-sqrt(r)<-r/s)
                interType=10;
            elseif (r>=p+sqrt(r/s))&&(p-sqrt(r/s)>=-r)&&(r/s>=q+sqrt(r))&&(q-sqrt(r)>=-r/s)
                interType=20;
            else
                error('Incorrect input!');
            end
        end
       
        if reverse==1  myVec=xInterVec; xInterVec=yInterVec; yInterVec=myVec; end        
    else
        interType=0;
    end


    if interType>20
        if reverse==0
            interType=defineType(xInterVec,yInterVec); 
        else 
            interType=defineType(yInterVec,xInterVec); 
        end
    end
    
    timeStep=maxTime/nTime;
    
    if isempty(xOptMat)==1
        xOptMat=zeros(2,nTime);
        uOptMat=zeros(2,nTime);
        psiOptMat=zeros(2,nTime);
        psiLastVec=[];
    end
    
    psiLastVec=1:floor(size(hugePsiMat,1)/2);
    for w=1:floor(size(hugePsiMat,1)/2)
        psiLastVec(w)=(findAlpha(hugePsiMat(2*w-1:2*w,2),p,q));
    end
    
    psiLastVec=sort(psiLastVec);
    
    
    if impFlag=='g'
        alphaVec=1:nL;
        alphaPiVec=alphaVec*2*pi/nL;
        lMat=[cos(alphaPiVec);sin(alphaPiVec)];
    else
        alphaVec=0:10;
        alphaOpt=findAlpha(psiOptMat(:,1),p,q);
        pos=find(psiLastVec==alphaOpt);
        if (pos>1)&&(pos<nL)
            aStep=abs(psiLastVec(pos-1)-psiLastVec(pos+1))/10;
            alphaVec=min(psiLastVec(pos-1),psiLastVec(pos+1))+aStep*alphaVec;
        elseif pos==1
            aStep=abs(psiLastVec(2))/10;
            alphaVec=aStep*alphaVec;
        else
            aStep=abs(2*pi-psiLastVec(nL-1))/10;
            alphaVec=psiLastVec(nL-1)+aStep*alphaVec;
        end       
        lMat=[cos(alphaVec);sin(alphaVec)];
    end
    
    optTime=prevOptTime;
    
    syms t tau real;
    
    expA=expm(aMat*(t-tau));
            
    timeStep=maxTime/nTime;
    timeVec=fliplr([0,(1:nTime)*timeStep]);
    
    
    xFundMat=zeros(2*(nTime+1));
    
    
    for m=1:(nTime+1)
        curTime=timeVec(m);
        expA=subs(expA,t,curTime);
        for k=1:m
            curTau=timeVec(k);
            cExpA=subs(expA,tau,curTau);
            xFundMat(2*m-1:2*m,2*k-1:2*k)=cExpA;
        end
    end 
       
    if impFlag=='l'
        nSteps=10;
    else
        nSteps=nL;
    end
        
    for k=1:nSteps
        psiLast=lMat(:,k);
        if ismember(findAlpha(psiLast,p,q),psiLastVec)==0
            [timeK,xMatK,uMatK,psiMatK,solFlag]=findTraj(psiLast,x1,aMat,bMat,fVec,maxTime,nTime,@supP,a,b,@supX,xv,yv,xInterVec,yInterVec,interType,s,p,q,r,startX,startY,xFundMat);
            if (timeK>optTime)&&(solFlag==1)
                optTime=timeK;
                xOptMat=xMatK;
                uOptMat=uMatK;
                psiOptMat=psiMatK;
            end
            curL=size(xMatK,2);
            hugeXMat=cat(1,hugeXMat,cat(2,cat(2,[curL;0],xMatK),zeros(2,nTime+1-curL)));
            hugeUMat=cat(1,hugeUMat,cat(2,cat(2,[curL;0],uMatK),zeros(2,nTime+1-curL)));
            hugePsiMat=cat(1,hugePsiMat,cat(2,cat(2,[curL;0],psiMatK),zeros(2,nTime+1-curL)));
        end
    end

    
    if optTime==0
        disp('There is no solution! Please, make more accurate calculations!');
    else
        solFlag=1;
        format long;
        disp('Optimal time is:')
        disp(maxTime-optTime);
        format short;
    end
    
   
    xStar=xOptMat(1,end);
    yStar=xOptMat(2,end);
    
    xDistVec=xv-xStar;
    yDistVec=yv-yStar;
    
    distVec=xDistVec.^2+yDistVec.^2;
    indOfMin=find(distVec==min(distVec),1);
    
    xStar=xv(indOfMin);
    yStar=yv(indOfMin);
    
    if solFlag==1
        xOptMat(1,end)=xStar;
        xOptMat(2,end)=yStar;
    end
    
    alpha=inverSupX(xStar,yStar,xInterVec,yInterVec,interType,s,p,q,r);
        
    mist=graphics(xOptMat,uOptMat,psiOptMat,hugeXMat,hugeUMat,hugePsiMat,alpha,maxTime,nTime,s,p,q,r,solFlag,aMat);
    
    if solFlag==1
        disp('The mistake is: ');
        disp(mist);
    end
    
    
end