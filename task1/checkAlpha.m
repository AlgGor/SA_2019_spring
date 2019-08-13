
    s=2;
    p=1;
    q=1.3;
    r=3;
    a=1;
    b=2;
        
    x1=[5;0];
   
    startX=5.0;
    startY=5.0;
    step=0.02;
    x=-startX:step:startX;
    y=-startY:step:startY;
    [xVec,yVec] = meshgrid(x,y);
    N=floor(4*(startX/step)*(startY/step));

    f0=@(xVec,yVec,s,p,q) max(abs(xVec)+s*abs(yVec),s*((xVec-p).^2)+(yVec-q).^2);
   
    if s<0
       error('Incorrect input!'); 
    end

    zMat=f0(xVec,yVec,s,p,q);
    surf(xVec,yVec,-zMat);

    [M,~]=contourf(xVec,yVec,-zMat,[-r, -r]);

    %disp(M);

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


%         hold on;
%         plot(xInterVec,yInterVec,'r');
%         hold off;
       
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
    
    
    %disp(interType);
     
    interMat=cat(1,xInterVec,yInterVec);
    interMat=(sortrows(interMat',2))';
    
    xVecS=fliplr(interMat(1,:));    
    yVecS=fliplr(interMat(2,:));
    
    xStar=xVecS(2);
    yStar=yVecS(2);
      
    hold on;
    plot(xStar,yStar,'rd');
    hold off;
    alpha=inverSupX(xStar,yStar,xInterVec,yInterVec,interType,s,p,q,r);
    
    if size(alpha,2)==1
        hold on;
        quiver(xStar,yStar,cos(alpha)/5,sin(alpha)/5);
        hold off;
        xNorm=[xStar-0.05,xStar+0.05];
        yNorm=[yStar-0.05*(-cot(alpha)),yStar+0.05*(-cot(alpha))];
        hold on;
        plot(xNorm,yNorm,'k');
        hold off;
    else
        stepVec=0:6;
        if isBetweenA1A2(0,alpha(2),alpha(1))
            disp('zero');
            aStep=(abs(2*pi-alpha(1))+alpha(2))/5;
            alphaVec=stepVec*aStep+alpha(1);
        elseif (alpha(2)-alpha(1))>pi
            disp('graeter than pi');
            aStep=(abs(2*pi-alpha(2))+alpha(1))/5;
            alphaVec=stepVec*aStep+alpha(2);
        else
            disp('less than pi');
            aStep=(alpha(2)-alpha(1))/5;
            alphaVec=stepVec*aStep+alpha(1);
        end
        hold on;
        quiver(repmat( xStar,1,7),repmat(yStar,1,7),cos(alphaVec)/5,sin(alphaVec)/5);
        hold off;
        for k=1:7
            xNorm=[xStar-0.05,xStar+0.05];
            yNorm=[yStar-0.05*(-cot(alphaVec(k))),yStar+0.05*(-cot(alphaVec(k)))];
            hold on;
            plot(xNorm,yNorm,'k');
            hold off;
        end
    end
    
    hold on;
    axis('equal');
    hold off;