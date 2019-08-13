%% check

    s=2;
    p=2.5;
    q=1.4;
    r=3.5;
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
        if M(2,1)>M(2,1+M(2,1))
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

    in=inpolygon(x1(1),x1(2),xv,yv);

    % plot(xv,yv);
    % hold on;
    % plot(x1(1),x1(2),'d');
    % axis([-5 5 -5 5]);
    % hold off;

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

        [xVec,yVec,degen]=findInter(s,p,q,r);
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
%         plot(xVec,yVec,'r');
%         hold off;
        if reverse==1  myVec=xVec; xVec=yVec; yVec=myVec; end


    else
        interType=0;
    end


    if interType>20
        if reverse==0
            interType=defineType(xVec,yVec); 
        else 
            interType=defineType(yVec,xVec); 
        end
    end

%    disp(xVec);
%    disp(yVec);
   lMat=findLVec(xVec,yVec,s,p,q,r);
    
   %pause(10);
   

   
   N=40;
  
   %disp(interType);
   
   %disp('Новый заход:');
   
   %drawset2(@supX,N,xVec,yVec,interType,s,p,q,r);
   
   drawset3(@supP,N,a,b);
   
   
   
   
   