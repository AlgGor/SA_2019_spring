%% Task 1 on OC

clear;

clFigures();
x
s=2;
p=2.21;
q=-0.2; %% -0.2  is cool
r=4.3;

x1=[0;-0.5];

aMat=[1,-2;4,-1];   %1,-2,3,-1 норм
bMat=[1,0;0,1];
fVec=[0;8];
a=1;
b=2;
maxTime=1;

disp('New try');

optTime=solFunc(s,p,q,r,x1,aMat,bMat,fVec,a,b,maxTime);