function interType=defineType(xVec,yVec)

    if size(xVec,2)==2
        if xVec(1)*xVec(2)>=0
            if yVec(1)*yVec(2)>=0
                if xVec(1)+xVec(2)>0
                    if yVec(1)+yVec(2)>0 interType=31;
                    else interType=34;
                    end
                else
                    if yVec(1)+yVec(2)>0 interType=32;
                    else interType=33;
                    end
                end    
            else
                if xVec(1)+xVec(2)>0 interType=51;
                else interType=52;
                end
            end
        else
            if yVec(1)*yVec(2)>=0
                if yVec(1)+yVec(2)>0 interType=61;
                else interType=62;
                end
            end
        end
    else
        if xVec(1)*xVec(2)*xVec(3)*xVec(4)>=0
            myVec=sort(xVec);
            if myVec(1)*myVec(4)>=0
                if xVec(1)+xVec(2)>0 interType=41;
                else interType=42;
                end
            else 
                interType=70;         
            end
        else
            solMat=[xVec;yVec];
            solMat=(sortrows(solMat'))';
            xVec=solMat(1,:);
            yVec=solMat(2,:);
            if (xVec(1)*xVec(2)<0)
                if yVec(1)>0  interType=82; 
                else interType=83; 
                end
            else
                if yVec(4)>0  interType=81; 
                else interType=84; 
                end
            end
            
        end
    end

end