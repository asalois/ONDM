% Create Proakis Synthetic Channel

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois

%% Preliminary commands 
close all;
clear all;
clc; 

%% System Paramters
Fs = 1000;
t = linspace(0,1,4*Fs);
x = cos(2*pi*10*t);


%% Channel Filter Paramters
b = [1 -1];
channel = filter(b,1,x);

figure()
plot(t,x)
figure()
plot(t,channel)

