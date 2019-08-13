function [val,supVec]=supRhombusCorner(lVec,xVec,yVec,s,r,p,q)


    l1=lVec(1);
    l2=lVec(2);    
    
    x1=xVec(1);
    y1=yVec(1);
    x2=xVec(2);
    y2=yVec(2);
    
    if((abs(l2/l1)==s)&&(((l1*x1>0)&&(l2*y1>0))||((l1*x2>0)&&(l2*y2>0))))
       if sign(l2)>=0
          supVec=[xVec(1);yVec(1)];
       else
           supVec=[xVec(2);yVec(2)];
       end
    elseif  (abs(l2/l1)<s)&&(l1*x1>0)
        supVec=[sign(l1)*r;0];
    else
        if (p>0)
            if findAlpha(lVec,p,q)<findAlpha([x1-p,y1-q],p,q)
                supVec=[x1,y1];
            else
                supVec=[x2,y2];
            end
        else
            if findAlpha(lVec,p,q)<findAlpha([x1-p,y1-q],p,q)
                supVec=[x2,y2];
            else
                supVec=[x1,y1];
            end
            
        end
    end
    
    val=dot(lVec,supVec);


end