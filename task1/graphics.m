function mist=graphics(xOptMat,uOptMat,psiOptMat,hugeXMat,hugeUMat,hugePsiMat,alpha,maxTime,nTime,s,p,q,r,solFlag,aMat) 
    
    timeStep=maxTime/nTime;
    timeVec=[0:nTime]*timeStep;
    answ='a';
    mist=0;
    nL=floor(size(hugeXMat,1)/2);
    myNm=crMyNm(aMat,s,p,q,r);
    
    while answ~='y'  
        
        if solFlag==1
            answ=input('Display all (a) the trajectories for x2(x1) or just optimal (o)? ','s');
        else
            answ='a';
        end
        
        clFigures();
        
        fig=figure(1);
        
        
        startX=10.0;
        startY=10.0;
        step=0.02;
        x=-startX:step:startX;
        y=-startY:step:startY;
        [xVec,yVec] = meshgrid(x,y);
 
        f0=@(xVec,yVec,s,p,q) max(abs(xVec)+s*abs(yVec),s*((xVec-p).^2)+(yVec-q).^2);

        zMat=f0(xVec,yVec,s,p,q);
        figure(1);
        surf(xVec,yVec,-zMat);
        contourf(xVec,yVec,-zMat,[-r, -r]);
        axis('equal');
        
        if answ=='a'            
            for m=1:nL
                curSize=hugeXMat(2*m-1,1);
                x1=fliplr(hugeXMat(2*m-1,2:curSize+1));
                x2=fliplr(hugeXMat(2*m,2:curSize+1));
                hold on;
                plot(x1,x2,'k');
                ylabel('x2');
                xlabel('x1');
                hold off;
            end
            if solFlag==1
                hold on;
                plot(xOptMat(1,:),xOptMat(2,:),'r','LineWidth',2);
                hold off;
            end
        else
            hold on;
            plot(xOptMat(1,:),xOptMat(2,:),'r','LineWidth',2);
            hold off;
        end
       
        if solFlag==1
            xStar=xOptMat(1,end);
            yStar=xOptMat(2,end);


            if size(alpha,2)==1
                hold on;
                LineSpec='k';
                quiver(xStar,yStar,cos(alpha)/5,sin(alpha)/5,LineSpec);
                LineSpec='r';
                quiver(xStar,yStar,psiOptMat(1,end)/5,psiOptMat(2,end)/5,LineSpec);
                hold off;
                xNorm=[xStar-0.02,xStar+0.02];
                yNorm=[yStar-0.02*(-cot(alpha)),yStar+0.02*(-cot(alpha))];
                hold on;
                plot(xNorm,yNorm,'k');
                hold off;
                mist=abs(sin( abs( alpha-findAlpha([psiOptMat(1,end),psiOptMat(2,end)],p,q) ) ));
            else
                stepVec=0:5;
                if (alpha(2)-alpha(1))>pi
                    aStep=(abs(2*pi-alpha(2))+alpha(1))/5;
                    alphaVec=stepVec*aStep+alpha(2);
                else
                    aStep=(alpha(2)-alpha(1))/5;
                    alphaVec=stepVec*aStep+alpha(1);
                end
                hold on;
                LineSpec='k';
                quiver(repmat( xStar,1,6),repmat(yStar,1,6),cos(alphaVec)/5,sin(alphaVec)/5,LineSpec);
                LineSpec='r';
                quiver(xStar,yStar,psiOptMat(1,end)/5,psiOptMat(2,end)/5,LineSpec);
                hold off;
                for k=1:6
                    xNorm=[xStar-0.05,xStar+0.05];
                    yNorm=[yStar-0.05*(-cot(alphaVec(k))),yStar+0.05*(-cot(alphaVec(k)))];
                    hold on;
                    plot(xNorm,yNorm,'k');
                    hold off;
                end
                mist=abs(sin( min( abs(alphaVec-findAlpha([psiOptMat(1,end),psiOptMat(2,end)],p,q) ) )));
            end
        end
        print(['my_pictures\intergTraj',myNm],'-dpng');

    
    
        figure(2);
        
        if solFlag==1
            answ=input('Display all (a) the trajectories for x1(t),x2(t) or just optimal (o)?  ','s');
        else
            answ='a';
        end
        
        if answ=='a'     
            for m=1:nL
                curSize=hugeXMat(2*m-1,1);
                x1=fliplr(hugeXMat(2*m-1,2:curSize+1));
                curTime=timeVec(1:curSize);
                hold on;
                plot(curTime,x1,'k');
                ylabel('x1');
                xlabel('time');
                hold off;
            end
            if solFlag==1
              hold on;
              curTime=timeVec(1:size(xOptMat,2));
              plot(curTime,fliplr(xOptMat(1,:)),'r','LineWidth',2);
              hold off;
            end
        else
            hold on;
            curTime=timeVec(1:size(xOptMat,2));
            plot(curTime,fliplr(xOptMat(1,:)),'r','LineWidth',2);
            ylabel('x1');
            xlabel('time');
            hold off;
        end
        print(['my_pictures\x1(t)',myNm],'-dpng');
        
        figure(3);
        if answ=='a'     
            for m=1:nL
                curSize=hugeXMat(2*m-1,1);
                x2=fliplr(hugeXMat(2*m,2:curSize+1));
                curTime=timeVec(1:curSize);
                hold on;
                plot(curTime,x2,'k');
                ylabel('x2');
                xlabel('time');
                hold off;              
            end
            if solFlag==1
              hold on;
              curTime=timeVec(1:size(xOptMat,2));
              plot(curTime,fliplr(xOptMat(2,:)),'r','LineWidth',2);
              hold off;
             end
        else
            hold on;
            curTime=timeVec(1:size(xOptMat,2));
            plot(curTime,fliplr(xOptMat(2,:)),'r','LineWidth',2);
            ylabel('x2');
            xlabel('time');
            hold off;
        end
        print(['my_pictures\x2(t)',myNm],'-dpng');
    
        figure(4);
        if solFlag==1
            answ=input('Display all (a) the trajectories for u1(t),u2(t), u1(u2) or just optimal (o)?    ','s');
        else
            answ='a';
        end
        
        if answ=='a' 
            for m=1:nL
                curSize=hugeUMat(2*m-1,1);
                u1=fliplr(hugeUMat(2*m-1,2:curSize+1));
                curTime=timeVec(1:curSize);
                hold on;
                plot(curTime,u1,'k');
                ylabel('u1');
                xlabel('time');
                hold off;
            end
            if solFlag==1
                hold on;
                curTime=timeVec(1:size(xOptMat,2));
                plot(curTime,fliplr(uOptMat(1,:)),'r','LineWidth',2);
                hold off;
            end
        else
            hold on;
            curTime=timeVec(1:size(uOptMat,2));
            plot(curTime,fliplr(uOptMat(1,:)),'r','LineWidth',2);
            ylabel('u1');
            xlabel('time');
            hold off;
        end
        print(['my_pictures\u1(t)',myNm],'-dpng');

        figure(5);
        if answ=='a' 
            for m=1:nL
                curSize=hugeXMat(2*m-1,1);
                u2=fliplr(hugeUMat(2*m,2:curSize+1));
                curTime=timeVec(1:curSize);
                hold on;
                plot(curTime,u2,'k');
                ylabel('u2');
                xlabel('time');
                hold off;
            end
            if solFlag==1
              hold on;
              curTime=timeVec(1:size(xOptMat,2));
              plot(curTime,fliplr(uOptMat(2,:)),'r','LineWidth',2);
              hold off;
            end
        else
            hold on;
            curTime=timeVec(1:size(uOptMat,2));
            plot(curTime,fliplr(uOptMat(2,:)),'r','LineWidth',2);
            ylabel('u2');
            xlabel('time');
            hold off;
        end
        print(['my_pictures\u2(t)',myNm],'-dpng');
    
       figure(6);
       if answ=='a' 
           for m=1:nL
                curSize=hugeUMat(2*m-1,1);
                u1=fliplr(hugeUMat(2*m-1,2:curSize+1));
                u2=fliplr(hugeUMat(2*m,2:curSize+1));
                hold on;
                plot(u2,u1,'kd');
                ylabel('u1');
                xlabel('u2');
                hold off;   
           end
           if solFlag==1
              hold on;
              curTime=timeVec(1:size(xOptMat,2));
              plot(fliplr(uOptMat(2,:)),fliplr(uOptMat(1,:)),'rd','LineWidth',2);
              hold off;
           end
           
       else
            hold on;
            plot(fliplr(uOptMat(2,:)),fliplr(uOptMat(1,:)),'rd','LineWidth',2);
            ylabel('u1');
            xlabel('u2');
            hold off;
       end 
       print(['my_pictures\u1(u2)',myNm],'-dpng');
    
       
        figure(7);
        if solFlag==1
             answ=input('Display all (a) the trajectories for psi1(t),psi2(t) or just optimal (o)?    ','s');
        else
            answ='a';
        end
        if answ=='a'
            for m=1:nL
                curSize=hugeXMat(2*m-1,1);
                psi1=fliplr(hugePsiMat(2*m-1,2:curSize+1));
                curTime=timeVec(1:curSize);
                hold on;
                plot(curTime,psi1,'k');
                ylabel('psi1')
                xlabel('time');
                hold off;
            end
            if solFlag==1
                hold on;
                curTime=timeVec(1:size(xOptMat,2));
                plot(curTime,fliplr(psiOptMat(1,:)),'r','LineWidth',2);
                hold off;
            end    
        else
            hold on;
            curTime=timeVec(1:size(psiOptMat,2));
            plot(curTime,fliplr(psiOptMat(1,:)),'r','LineWidth',2);
            ylabel('psi1');
            xlabel('time');
            hold off;
        end 
        print(['my_pictures\psi1(t)',myNm],'-dpng');

        figure(8);
        if answ=='a'
            for m=1:nL
                curSize=hugeXMat(2*m-1,1);
                psi2=fliplr(hugePsiMat(2*m,2:curSize+1));
                curTime=timeVec(1:curSize);
                hold on;
                plot(curTime,psi2,'k');
                ylabel('psi2');
                xlabel('time');
                hold off;
            end
            if solFlag==1
              hold on;
              curTime=timeVec(1:size(xOptMat,2));
              plot(curTime,fliplr(psiOptMat(2,:)),'r','LineWidth',2);
              hold off;
            end  
        else 
            hold on;
            curTime=timeVec(1:size(psiOptMat,2));
            plot(curTime,fliplr(psiOptMat(2,:)),'r','LineWidth',2);
            ylabel('psi2');
            xlabel('time');
            hold off;
        end 
        print(['my_pictures\psi2(t)',myNm],'-dpng');
         
        disp('');
        if solFlag==1
            answ=input('Quit graphics?: (y)/(n)   ','s');
        else
            answ='y';
        end
        
    end
end