function [val,supVec]=supX(lVec,xVec,yVec,interType,s,p,q,r)

    l1=lVec(1);
    l2=lVec(2);
    sl1=sign(l1);
    sl2=sign(l2);
    interMat=cat(1,xVec,yVec);
    interMat=(sortrows(interMat',2))';
    xVecS=fliplr(interMat(1,:));    
    yVecS=fliplr(interMat(2,:));        % точки пересечения отсортированы по y по убыванию
    
    
    lMat=findLVec(xVecS,yVecS,s,p,q,r);
    
    switch floor(interType/10)
        case 0  
            supVec=[sl1*r,q+sl2*sqrt(r)];
            val=dot(lVec,supVec);
        case 1
            if abs(l2/l1)==abs(s)
                supVec=[sign(l1)*r/(1+s^2);sign(l2)*abs(s)*r/(1+s^2)];
            elseif  abs(l2/l1)<abs(s)
                supVec=[sign(l1)*r;0];
            else
                supVec=[0;sign(l2)*r/s];
            end
            val=dot(lVec,supVec);
        case 2    
            [val,supVec]=supEllShift(lVec,s,p,q,r);
        case 3
            if isBetweenL1L2(lVec,lMat(:,1),lMat(:,2),p,q)==1  
                [val,supVec]=supEllShift(lVec,s,r,p,q);
            else
                [val,supVec]=supRhombusSide(lVec,xVec,yVec,s,r);
            end
        case 4
            alphaL1=findAlpha(lMat(:,1),p,q);
            alphaL2=findAlpha(lMat(:,2),p,q);
            alphaL3=findAlpha(lMat(:,3),p,q);
            alphaL4=findAlpha(lMat(:,4),p,q);
            
            if abs(alphaL1-alphaL2)<abs(alphaL3-alphaL4)
                if isBetweenL1L2(lVec,lMat(:,1),lMat(:,2),p,q)==1 
                    [val,supVec]=supRhombusSide(lVec,xVecS(1:2),yVecS(1:2),s,r);
                elseif (isBetweenL1L2(lVec,lMat(:,2),lMat(:,3),p,q)==1)||(isBetweenL1L2(lVec,lMat(:,1),lMat(:,4),p,q)==1)
                    [val,supVec]=supEllShift(lVec,s,r,p,q);
                else
                    [val,supVec]=supRhombusSide(lVec,xVecS(3:4),yVecS(3:4),s,r);
                end
            else
                if isBetweenL1L2(lVec,lMat(:,3),lMat(:,4),p,q)==1 
                    [val,supVec]=supRhombusSide(lVec,xVecS(3:4),yVecS(3:4),s,r);
                elseif (isBetweenL1L2(lVec,lMat(:,2),lMat(:,3),p,q)==1)||(isBetweenL1L2(lVec,lMat(:,1),lMat(:,4),p,q)==1)
                    [val,supVec]=supEllShift(lVec,s,r,p,q);
                else
                    [val,supVec]=supRhombusSide(lVec,xVecS(1:2),yVecS(1:2),s,r);
                end
            end                
        case 5
            if isBetweenL1L2(lVec,lMat(:,1),lMat(:,2),p,q)==1 
                [val,supVec]=supEllShift(lVec,s,r,p,q);
            else 
                [val,supVec]=supRhombusCorner(lVec,xVecS,yVecS,s,r,p,q);
            end    
        case 6
            if isBetweenL1L2(lVec,lMat(:,1),lMat(:,2),p,q)==1 
                [val,supVec]=supEllShift(lVec,s,r,p,q);
            else
                [val,supVec]=supRhombusTop(lVec,xVec,yVec,s,r);
            end  
        case 7    
            if (isBetweenL1L2(lVec,lMat(:,1),lMat(:,2),p,q)==1) 
                [val,supVec]=supRhombusTop(lVec,xVecS(1:2),yVecS(1:2),s,r);
            elseif isBetweenL1L2(lVec,lMat(:,3),lMat(:,4),p,q)==1
                [val,supVec]=supRhombusTop(lVec,xVecS(3:4),yVecS(3:4),s,r);
            else
                [val,supVec]=supEllShift(lVec,s,r,p,q);
            end
        case 8
            if (interType-10*floor(interType/10))<3
                if (isBetweenL1L2(lVec,lMat(:,1),lMat(:,2),p,q)==1) 
                    [val,supVec]=supRhombusTop(lVec,xVecS(1:2),yVecS(1:2),s,r);
                elseif isBetweenL1L2(lVec,lMat(:,3),lMat(:,4),p,q)==1
                    [val,supVec]=supRhombusSide(lVec,xVecS(3:4),yVecS(3:4),s,r);
                else
                    [val,supVec]=supEllShift(lVec,s,r,p,q);
                end
            else
                if (isBetweenL1L2(lVec,lMat(:,3),lMat(:,4),p,q)==1) 
                    [val,supVec]=supRhombusTop(lVec,xVecS(3:4),yVecS(3:4),s,r);
                elseif isBetweenL1L2(lVec,lMat(:,1),lMat(:,2),p,q)==1
                    [val,supVec]=supRhombusSide(lVec,xVecS(1:2),yVecS(1:2),s,r);
                else
                    [val,supVec]=supEllShift(lVec,s,r,p,q);
                end
            end
        otherwise
            error('are you joking?'); 
    end
        
end