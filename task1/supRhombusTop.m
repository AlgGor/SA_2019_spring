function [val,supVec]=supRhombusTop(lVec,xVec,yVec,s,r)
    

    l1=lVec(1);
    l2=lVec(2);
    
    x1=xVec(1);
    y1=yVec(1);
    x2=xVec(2);
    y2=yVec(2);
   
    pointMat=(sortrows([xVec;yVec]'))';
    xVec=pointMat(1,:); 
    yVec=pointMat(2,:);  % отсортировано по х по возрастанию
    
    if ((abs(l2/l1)==s)&&(l1*x1>0)&&(l2*y1>0))
        supVec=[sign(l1)*min(abs(x1),abs(x2));sign(l2)*max(abs(y1),abs(y2))];
    elseif  ((abs(l2/l1)>s)&&(l2*y1>0))
        supVec=[0;sign(l2)*r/s];
    else
        if sign(l1)>=0
            supVec=[xVec(2);yVec(2)];
        else
            supVec=[xVec(1);yVec(1)];
        end  
    end
    
    val=dot(lVec,supVec);




end