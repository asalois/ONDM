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
d = load('data_test.mat');
d.data = d.data(1:29,:);
t = load('target_test.mat');
test = 2^15;
% diff  = length(d.data) - length(t.target)
size(d.data)
size(t.target)

%%
% Define network
hLayers = 70/2; % hidden layer size
Eq_simple_net = fitnet(hLayers,'traingd'); % make a fitnet
Eq_simple_net.layers{1}.transferFcn = 'purelin'; % have the actuvation be linear

% Train the Network
[Eq_simple_net,TT] = train(Eq_simple_net,d.data(:,1:end-test),t.target(1:end-test),'useGPU', 'yes'); % use when gpu
% [Eqnet,TT] = train(Eqnet,d.data,t.target); % use when no gpu and small data
% [Eqnet,TT] = train(Eqnet,d.data,t.target,'useParallel','yes'); % use when no gpu and large data

%% Test the Network
output = Eq_simple_net(d.data(:,end-test:end));
err = output == t.target(end-test:end);
sum(err)
perCentErr = sum(err)/test
% output = [output(1,:) + output(2,:)*1i]';
save Eq_simple_net

%%


toc

