%% make a unitary matrix of NxN

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois

%% Preliminary commands 

close all;
clear all;
clc; 

%% gebnerate random numbers from normal dist
N = 2;
rr = normrnd(0,1);
ri = rr + rr*i;
rrM = normrnd(0,1,N,N);
rrM = rrM + rrM*i;
U = orth(rrM);
U'*U
U*U'
eye(N)