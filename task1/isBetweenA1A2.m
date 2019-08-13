function flag= isBetweenA1A2(alphaL,alphaL1,alphaL2)

    if ((max(alphaL1,alphaL2)-min(alphaL1,alphaL2))>pi)
        if ((alphaL>=max(alphaL1,alphaL2))&&(alphaL<=(min(alphaL1,alphaL2)+2*pi))) ||( (alphaL<=min(alphaL1,alphaL2))&&(alphaL>=(max(alphaL1,alphaL2)-2*pi)) )
            flag=1;
        else
            flag=0;
        end
    elseif (alphaL<=max(alphaL1,alphaL2))&&(alphaL>=min(alphaL1,alphaL2))
        flag=1;
    else            
        flag=0;
    end
    
end