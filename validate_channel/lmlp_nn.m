%% Proakis Synthetic Channel Equilization

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clc;
clear;
close all;

% time simulation
tic

% Specify a seed for the random number generators to ensure repeatability.
rng(12345)
d = load('data.mat');
t = load('target.mat');
test = 2^15;
% diff  = length(d.data) - length(t.target)
size(d.data)
size(t.target)

%%
% Define network
hLayers = 70; % hidden layer size
Eqnet = fitnet(hLayers,'traingd'); % make a fitnet
Eqnet.layers{1}.transferFcn = 'purelin'; % have the actuvation be linear
Eqnet.layers{2}.transferFcn = 'purelin'; % have the actuvation be linear

Eqnet.trainParam.showWindow=false;
Eqnet.trainParam.showCommandLine=true;
Eqnet.trainParam.epochs=2000;
%
% Train the Network
[Eqnet,TT] = train(Eqnet,d.data(:,1:end-test),t.target(:,1:end-test),'useGPU', 'yes'); % use when gpu
% Eqnet,TT] = train(Eqnet,d.data(:,1:end-test),t.target(:,1:end-test)); % use when no gpu and small data
% [Eqnet,TT] = train(Eqnet,d.data(:,1:end-test),t.target(:,1:end-test),'useParallel','yes'); % use when no gpu and large data

%% Test the Network
output = Eqnet(d.data(:,end-test:end));
output = [output(1,:) + output(2,:)*1i];
msg_test = qamdemod(output,4);

%%
msg = qamdemod([t.target(1,end-test:end) + t.target(2,end-test:end)*1i],4); 
[num_wrong,berNN] = biterr(msg,msg_test)
save('Eqnet','Eqnet')
x = cell2mat(Eqnet.LW(2));
w = [x(1,:) + x(2,:)*1i];
save('w','w');
toc

