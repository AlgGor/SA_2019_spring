function lMat=findLVec(xVec,yVec,s,p,q,r)
    
    lMat=[];
    a=r/s;
    b=r;
    xVec=xVec-p;
    yVec=yVec-q;
    for k=1:size(xVec,2)
        if yVec(k)==0
           lMat=cat(2,lMat,[sign(xVec(k));0]);
           continue
        end
        gamma=abs(xVec(k)/yVec(k));
        l1=sign(xVec(k))*sqrt((b^2*gamma^2)/(b^2*gamma^2+a^2));
        l2=sign(yVec(k))*sqrt(a^2/(b^2*gamma^2+a^2));
        lMat=cat(2,lMat,[l1;l2]);
    end

end