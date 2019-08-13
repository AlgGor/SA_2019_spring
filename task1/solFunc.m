function oTime=solFunc(s,p,q,r,x1,aMat,bMat,fVec,a,b,maxTime)

    hugeXMat=[];
    hugeUMat=[];
    hugePsiMat=[];
    oTime=0;
    xOptMat=[];
    uOptMat=[];
    psiOptMat=[];
    nL=50;
    nTime=20;
    [oTime,xOptMat,uOptMat,psiOptMat,hugeXMat,hugeUMat,hugePsiMat,solFlag]=optTime(s,p,q,r,x1,aMat,bMat,fVec,a,b,maxTime,xOptMat,uOptMat,psiOptMat,hugeXMat,hugeUMat,hugePsiMat,oTime,nL,nTime,'g');
    
    answ=input('Do you want to more accurate calculations? y/n ','s');

    
    while answ=='y'
        if solFlag==1
            answ= input('Which type would you choose? local (l) or general (g) ','s');
        else
            answ='g';
        end
        
        if answ=='l'
            impFlag='l';
        else
            impFlag='g';
            nL=nL*2;
        end
        [oTime,xOptMat,uOptMat,psiOptMat,hugeXMat,hugeUMat,hugePsiMat,solFlag] = opTime(s,p,q,r,x1,aMat,bMat,fVec,a,b,maxTime,xOptMat,uOptMat,psiOptMat,hugeXMat,hugeUMat,hugePsiMat,oTime,nL,nTime,impFlag);
        
        answ=input('Do you want to more accurate calculations? y/n ','s');
    end
    
end
