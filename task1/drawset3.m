function drawset3(rho,N,a,b)
    
    cla;
    alphaVec=1:N;
    alphaPiVec=alphaVec*2*pi/N;
    xVec=cos(alphaPiVec);
    yVec=sin(alphaPiVec);
    xSupVec=1:N;
    ySupVec=1:N;
    
    for k=1:N
        [~,point]=rho([xVec(k);yVec(k)],a,b);
        xSupVec(k)=point(1);
        ySupVec(k)=point(2);
        hold on;
        plot(xSupVec(k),ySupVec(k),'bd');
        hold off;   
        pause(0.5);
    end
    
    hold on;    
    plot(xSupVec,ySupVec,'g',[xSupVec(N),xSupVec(1)],[ySupVec(N),ySupVec(1)],'g');
    xlim([-5 5]);
    ylim([-5 5]);
    hold off;  
end