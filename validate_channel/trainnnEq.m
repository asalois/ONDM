%% Proakis Synthetic Channel Equilization

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
% clc;
clear;
close all;

% Specify a seed for the random number generators to ensure repeatability.
rng(12345)
berNN = 1;


%% Make and Train EQ

% Define network
hLayers = 70; % hidden layer size
Eqnet = fitnet(hLayers,'traingd'); % make a fitnet
Eqnet.layers{1}.transferFcn = 'purelin'; % have the actuvation be linear
Eqnet.trainParam.epochs = 20000;

tic
[train_data, target] = get_train_data(10);
% [Eqnet,TT] = train(Eqnet,train_data,target,'useParallel','yes'); % use when no gpu and small data
[Eqnet,TT] = train(Eqnet,train_data,target,'useGPU', 'yes'); % use when gpu
% [Eqnet,TT] = train(Eqnet,train_data,target); % use when no gpu and small data
toc

%% test EQ
[train_data, target] = get_train_data(20);
test = [target(1,:) + target(2,:)*1i]';
% Test the Network
output = Eqnet(train_data);
output = [output(1,:) + output(2,:)*1i]';

x = qamdemod(test,4);
y = qamdemod(output,4);
% find BER
[~,berNN] = biterr(x,y)


save Eqnet

%% Train in a Loop
tic
load Eqnet
for i = 1:1000
    [train_data, target] = get_train_data(10);
    
    % Train the Network
    % [Eqnet,TT] = train(Eqnet,d.data,t.target','useGPU', 'yes'); % use when gpu
    [Eqnet,TT] = train(Eqnet,train_data,target); % use when no gpu and small data
    % [Eqnet,TT] = train(Eqnet,d.data,t.target,'useParallel','yes'); % use when no gpu and large data
end
save Eqnet
toc

%% Test EQ
[train_data, target] = get_train_data(20);
test = [target(1,:) + target(2,:)*1i]';
% Test the Network
output = Eqnet(train_data);
output = [output(1,:) + output(2,:)*1i]';

x = qamdemod(test,4);
y = qamdemod(output,4);
% find BER
[~,berNN] = biterr(x,y)

