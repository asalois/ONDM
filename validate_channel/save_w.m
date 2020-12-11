%% Proakis Synthetic Channel Equilization

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clc;
clear;
close all;

load('Eqnet.mat')
x = cell2mat(Eqnet.LW(2));
x = x';
b = cell2mat(Eqnet.b(1));
z = [x(:,1)+b x(:,2)+b];
b = cell2mat(Eqnet.b(2));
z = [x(:,1)+b(1) x(:,2)+b(2)];
w = [x(:,1) + x(:,2)*1i];
save('w','w');

