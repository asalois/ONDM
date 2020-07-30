%% make a unitary matrix of NxN

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois

%% Preliminary commands 

close all;
clear all;
clc; 

%% gebnerate random numbers from normal dist
N = 500;
rr = normrnd(0,1);
ri = rr + rr*i;
rrM = normrnd(0,1,N,N);
rrM = rrM + rrM*i;
U = orth(rrM);
U1 = U'*U; 
U2 = U*U';
id = eye(N);
