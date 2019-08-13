function alpha=inverSupX(xStar,yStar,xVec,yVec,interType,s,p,q,r)

    function alpha=invTop(xStar,yStar,xVec,yVec,interType,s,p,q,r)
            
            interMat=cat(1,xVec,yVec);
            interMat=(sortrows(interMat',2))';

            xVecS=fliplr(interMat(1,:));    
            yVecS=fliplr(interMat(2,:));        % точки пересечения отсортированы по y по убыванию

            lMat=findLVec(xVecS,yVecS,s,p,q,r);
            aL1=findAlpha(lMat(:,1),p,q);
            aL2=findAlpha(lMat(:,2),p,q);
            if size(lMat,2)>2
                aL3=findAlpha(lMat(:,3),p,q);
                aL4=findAlpha(lMat(:,4),p,q);
            end

            aS1=atan(s);            %% соответствует четвертям 
            aS2=pi-aS1;
            aS3=pi+aS1;
            aS4=2*pi-aS1;

            aC=findAlpha([xStar-p,yStar-q],p,q);
        
           if (xStar~=xVec(1))&&(xStar~=xVec(2))&&(yStar~=yVec(1))&&(yStar~=yVec(2))&&(yStar~=0)
                if isBetweenA1A2(aC,aL1,aL2)==1 
                    alpha=aC;
                elseif (xStar>0)&&(yStar>0)
                    alpha=aS1;
                elseif (xStar>0)&&(yStar<0)
                    alpha=aS4;
                elseif (xStar<0)&&(yStar>0)
                    alpha=aS2;
                else
                    alpha=aS3;
                end
           else
               if yStar>=0
                   if xStar==0
                        alpha=[aS1,aS2];    
                   else
                      if xStar>0
                          alpha=[aC,aS1];
                      else
                          alpha=[aS2,aC];
                      end
                   end
               else
                    if yStar==0
                        alpha=[aS2,aS3];
                    else
                       if xStar>0
                           alpha=[aS4,aC];
                      else
                          alpha=[aC,aS3];
                      end
                    end
                end            
            end  
    end
    
    
    interMat=cat(1,xVec,yVec);
    interMat=(sortrows(interMat',2))';
    
    xVecS=fliplr(interMat(1,:));    
    yVecS=fliplr(interMat(2,:));        % точки пересечения отсортированы по y по убыванию
        
    lMat=findLVec(xVecS,yVecS,s,p,q,r);
    aL1=findAlpha(lMat(:,1),p,q);
    aL2=findAlpha(lMat(:,2),p,q);
    if size(lMat,2)>2
        aL3=findAlpha(lMat(:,3),p,q);
        aL4=findAlpha(lMat(:,4),p,q);
    end
    
    aS1=atan(s);            %% соответствует четвертям 
    aS2=pi-aS1;
    aS3=pi+aS1;
    aS4=2*pi-aS1;
    
    aC=findAlpha([xStar-p,yStar-q],p,q);
    
    secondDigit=interType-10*floor(interType/10);
    
    
    
    switch floor(interType/10)
        case 0  
            if (abs(xStar)~=r)||(abs(yStar-q)~=sqrt(r))
                if abs(xStar)>abs((yStar-q)*sqrt(r)/r)
                    alpha=[sign(xStar),0];
                else
                    alpha=[0,sign(yStar)];
                end
            else
                if yStar*xStar>=0
                    alpha=[pi/2*(1-sign(xStar)),pi-pi*sign(yStar)/2];
                else
                    alpha=[pi+pi/2*sign(xStar),3/2*pi-pi*sign(yStar)/2];
                end
            end
        case 1
            if (xStar>0)&&(yStar>0)
                alpha=aS1;
            elseif (xStar>0)&&(yStar<0)
                alpha=aS4;
            elseif (xStar<0)&&(yStar>0)
                alpha=aS2;
            elseif (xStar<0)&&(yStar<0)
                alpha=aS3;
            else
                if isBetweenA1A2(aC,aS1,aS2)==1
                    alpha=[aS1,aS2];
                elseif isBetweenA1A2(aC,aS2,aS3)==1
                    alpha=[aS2,aS3];
                elseif isBetweenA1A2(aC,aS3,aS4)==1
                    alpha=[aS3,aS4];
                else
                    alpha=[aS4,aS1];
                end    
            end
        case 2    
            alpha=aC;
        case 3
            if (xStar~=xVec(1))&&(xStar~=xVec(2))&&(yStar~=yVec(1))&&(yStar~=yVec(2))
                if (xStar>0)&&(yStar>0)
                    alpha=aS1;
                elseif isBetweenA1A2(aC,aL1,aL2)
                    alpha=aC;
                elseif (xStar>0)&&(yStar<0)
                    alpha=aS4;
                elseif (xStar<0)&&(yStar>0)
                    alpha=aS2;
                else
                    alpha=aS3;
                end
            else
                if xStar>=0
                   if yStar>=0
                        if isBetweenA1A2(aC,aL2,aS1)==1
                            alpha=[aL2,aS1];
                        else
                            alpha=[aS1,aL1];
                        end
                   else
                        if isBetweenA1A2(aC,aL1,aS4)==1
                            alpha=[aS4,aL1];
                        else
                            alpha=[aL2,aS4];
                        end
                   end
                else
                    if yStar>=0
                        if isBetweenA1A2(aC,aL2,aS2)==1
                            alpha=[aS2,aL2];
                        else
                            alpha=[aL1,aS2];
                        end
                   else
                        if isBetweenA1A2(aC,aL1,aS3)==1
                            alpha=[aL1,aS3];
                        else
                            alpha=[aS3,aL2];
                        end
                    end
                end
            end  
        case 4
           if (xStar~=xVec(1))&&(xStar~=xVec(2))&&(yStar~=yVec(1))&&(yStar~=yVec(2))&&(xStar~=xVec(3))&&(xStar~=xVec(3))&&(yStar~=yVec(4))&&(yStar~=yVec(4))
                if (isBetweenA1A2(aC,aL1,aL4)==1 )||(isBetweenA1A2(aC,aL2,aL3)==1)
                    alpha=aC; 
                elseif (xStar>0)&&(yStar>0)
                    alpha=aS1;
                elseif (xStar>0)&&(yStar<0)
                    alpha=aS4;
                elseif (xStar<0)&&(yStar>0)
                    alpha=aS2;
                else
                    alpha=aS3;
                end
            else
                if xStar>=0
                   if yStar>=0
                        if isBetweenA1A2(aC,aL2,aS1)==1
                            alpha=[aL2,aS1];
                        else
                            alpha=[aS1,aL1];
                           
                        end
                   else
                        if isBetweenA1A2(aC,aL3,aS4)==1
                            alpha=[aS4,aL3];
                        else
                            alpha=[aL4,aS4];
                        end
                   end
                else
                    if yStar>=0
                        if isBetweenA1A2(aC,aL2,aS2)==1
                            alpha=[aS2,aL2];
                        else
                            alpha=[aL1,aS2];
                        end
                   else
                        if isBetweenA1A2(aC,aL3,aS3)==1
                            alpha=[aL3,aS3];
                        else
                            alpha=[aS3,aL4];
                        end
                    end
                end 
           end
               
        case 5
            if (xStar~=xVec(1))&&(xStar~=xVec(2))&&(yStar~=yVec(1))&&(yStar~=yVec(2))&&(yStar~=0)
                if isBetweenA1A2(aC,aL1,aL2)==1 
                    alpha=aC;
                elseif (xStar>0)&&(yStar>0)
                    alpha=aS1;
                elseif (xStar>0)&&(yStar<0)
                    alpha=aS4;
                elseif (xStar<0)&&(yStar>0)
                    alpha=aS2;
                else
                    alpha=aS3;
                end
            else
               if xStar>=0
                   if yStar==0
                        alpha=[aS4,aS1];    
                   else
                       if yStar>0
                          
                            if isBetweenA1A2(aC,0,aS1)==1
                                alpha=[0,aS1];
                            else
                                alpha=[aS1,aL1];
                            end
                       else
                           if isBetweenA1A2(aC,2*pi,aS4)==1
                                alpha=[S4,2*pi];
                            else
                                alpha=[aL2,aS4];
                            end
                       end
                    end
               else
                    if yStar==0
                        alpha=[aS2,aS3];
                    else
                       if yStar>0
                            if isBetweenA1A2(aC,pi,aS2)==1
                                alpha=[aS2,pi];
                            else
                                alpha=[aL1,aS2];
                            end
                       else
                            if isBetweenA1A2(aC,pi,aS3)==1
                                alpha=[pi,S3];
                            else
                                alpha=[aS3,aL2];
                            end
                       end
                    end
                end            
            end    
        case 6
            alpha=invTop(xStar,yStar,xVec,yVec,interType,s,p,q,r);
        case 7    
            if (xStar~=xVec(1))&&(xStar~=xVec(2))&&(yStar~=yVec(1))&&(yStar~=yVec(2))&&(xStar~=xVec(3))&&(xStar~=xVec(3))&&(yStar~=yVec(4))&&(yStar~=yVec(4))&&(xStar~=0)
                if (isBetweenA1A2(aC,aL1,aL4)==1 )||(isBetweenA1A2(aC,aL2,aL3)==1)
                    alpha=aC;
                elseif (xStar>0)&&(yStar>0)
                    alpha=aS1;
                elseif (xStar>0)&&(yStar<0)
                    alpha=aS4;
                elseif (xStar<0)&&(yStar>0)
                    alpha=aS2;
                else
                    alpha=aS3;
                end
            else        
                if xStar>0
                    if yStar>0
                        alpha=[aC,aS1];
                    else
                        alpha=[aC,aS3];
                    end
                else
                    if yStar>0
                        alpha=[aS2,aC];
                    else
                        alpha=[aC,aS4];
                    end
                end
            end
        case 8
            if (xStar~=xVec(1))&&(xStar~=xVec(2))&&(yStar~=yVec(1))&&(yStar~=yVec(2))&&(xStar~=xVec(3))&&(xStar~=xVec(3))&&(yStar~=yVec(4))&&(yStar~=yVec(4))&&(xStar~=0)
                if (isBetweenA1A2(aC,aL1,aL4)==1 )||(isBetweenA1A2(aC,aL2,aL3)==1)
                    alpha=aC;
                elseif (xStar>0)&&(yStar>0)
                    alpha=aS1;
                elseif (xStar>0)&&(yStar<0)
                    alpha=aS4;
                elseif (xStar<0)&&(yStar>0)
                    alpha=aS2;
                else
                    alpha=aS3;
                end
            else
                if p>0
                    if yStar>0
                        alpha=invTop(xStar,yStar,xVec(1:2),yVec(1:2),interType,s,p,q,r);
                    else
                        if xStar>0
                            alpha=[min(aC,aS4),max(aC,aS4)];
                        else
                            alpha=[min(aC,aS3),max(aC,aS3)];
                        end
                    end    
                else
                    if yStar>0
                        if xStar>0
                           alpha=[min(aC,aS1),max(aC,aS1)];
                        else
                            alpha=[min(aC,aS2),max(aC,aS2)];
                        end
                    else
                        alpha=invTop(xStar,yStar,xVec(3:4),yVec(3:4),interType,s,p,q,r);
                    end
                end
              
            end 
        otherwise
            error('are you joking?'); 
    end
        
end