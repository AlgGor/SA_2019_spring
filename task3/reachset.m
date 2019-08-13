function reachset(alpha,maxT)
    
    clf;
    
    curT=0;
    N=50; % number of trajectories
    xVec0=[0,0];
    
    options= odeset('Events',@find_t_star); 
    
   swMat=[];  % swutch line
   xEdgeMat=[]; % edge of reachable set    
   
   % solve s+ and s-
    for l=1:2
    
        [tVecSol,xVecSol,te,xeVec,ie] = ode45(@(t,xVec) s_star(t,xVec,alpha),[0 maxT],xVec0,options);  % find t_star, where x2=0

        %disp(xVecSol);
%         hold on;
%         plot(xVecSol(:,1),xVecSol(:,2),'b');
%         hold off;

        if size(te)==1
            t_star=maxT;
            tVec=linspace(curT,t_star,N);
            N=N-1;  
        else
            t_star=te(2);
            tVec=linspace(curT,t_star,N);
        end


        x1Vec = interp1(tVecSol, xVecSol(:,1),tVec,'PCHIP');
        x2Vec = interp1(tVecSol, xVecSol(:,2),tVec,'PCHIP');
        x0Mat=cat(2,x1Vec',x2Vec');

        %disp(x0Mat);
        
        % to solve the problem with alpha>2.5 I decided to calculate first
        % and last traj and plot it
           
        % the first traj
        
        [swTrajMat,xEdgeVec,trajMat]=find_traj_fl(x0Mat(2,:),tVec(2),maxT,alpha);
        swMat=cat(1,swMat,swTrajMat);
%         hold on;
%         plot(trajMat(:,1),trajMat(:,2),'k');
%         hold off;
        xEdgeMat=cat(1,xEdgeMat,xEdgeVec);
        
        % other traj 
        for k=3:N-1
            [swTrajMat,xEdgeVec]=find_traj(x0Mat(k,:),tVec(k),maxT,alpha);
            swMat=cat(1,swMat,swTrajMat);
            xEdgeMat=cat(1,xEdgeMat,xEdgeVec);
        end
        
        %the last traj
        
        [swTrajMat,xEdgeVec,trajMat]=find_traj_fl(x0Mat(N,:),tVec(N),maxT,alpha);
        swMat=cat(1,swMat,swTrajMat);
%         hold on;
%         plot(trajMat(:,1),trajMat(:,2),'k');
%         hold off;
        xEdgeMat=cat(1,xEdgeMat,xEdgeVec);
                
%         hold on;
%         if l==1
%             plot(swMat(:,1),swMat(:,2),'bo',xEdgeMat(:,1),xEdgeMat(:,2),'g');
%         else
%             plot(swMat(N:(end),1),swMat(N:(end),2),'bo',xEdgeMat(N:(end),1),xEdgeMat(N:(end),2),'r');
%         end
%         hold off; 
    
        % closure
        if l==2
            xEdgeMat=cat(1,xEdgeMat,xEdgeMat(1,:));
        end
        
        alpha=-alpha;
        
    end
   
    
    hold on;
    ylabel('x2');
    xlabel('x1');
    plot(swMat(:,1),swMat(:,2),'bo',xEdgeMat(:,1),xEdgeMat(:,2),'g*');
    
   
    hold off; 
    
    aVec=axis;
    xMin=aVec(1);
    xMax=aVec(2);
   
    % find resilient points
    [sp_Vec,isResilVec]=find_special(xMin,xMax,alpha);
    
    hold on;
        plot(sp_Vec(1:3),0,'dk','LineWidth', 2);
    hold off;
    
    print(['my_pict\intergTraj4'],'-dpng');
%         hold on;
%         plot(x1Vec,x2Vec,'ro');
%         hold off;
        
    end
    
            
    