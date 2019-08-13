%% Task2
clear;


m0=300; 
M=100;
g=5;
l=2000; 
u_max=10;
T=6;
H=29;

[H_max,tau_sw_Vec]=part1(m0,M,g,u_max,l,T);

disp('opt:');
disp(H_max);
disp(tau_sw_Vec);

% [L_min,tau_sw_Vec]=part2(m0,M,g,u_max,l,T,H);
% disp('opt:');
% disp(L_min);
% disp(tau_sw_Vec);
