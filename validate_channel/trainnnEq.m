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
berNN = 1;

d = load('data.mat');
t = load('target.mat');

%%
% Define network
hLayers = 70; % hidden layer size
Eqnet = fitnet(hLayers,'traingd'); % make a fitnet
Eqnet.layers{1}.transferFcn = 'purelin'; % have the actuvation be linear

% Train the Network
% [Eqnet,TT] = train(Eqnet,d.data,t.target','useGPU', 'yes'); % use when gpu
% [Eqnet,TT] = train(Eqnet,d.data,t.target); % use when no gpu and small data
[Eqnet,TT] = train(Eqnet,d.data,t.target,'useParallel','yes'); % use when no gpu and large data

% Test the Network
output = Eqnet(testData);
output = [output(1,:) + output(2,:)*1i]';
save Eqnet

%%
while berNN > 0.49

    % Use NN
    trainNN = length(symbols)/2;
    perCent = trainNN/length(symbols);
    symbols = circshift(symbols,-1);
    rx5Sig = nnEq(filtSig,symbols,trainNN);
    sr = shiftCheck(rx5Sig,symbols(trainNN+1:end), length(rx5Sig))
    sl = length(rx5Sig) - sr
    bkEst = qamdemod(rx5Sig,M);
%     shift = shiftCheck(msg(trainNN+1:end),bkEst, 2^8)   
    shift = 0;
    x = msg(trainNN:end-1);
    y = circshift(bkEst,shift);
    diff = length(x) - length(y);
    diff
    % find BER
    [~,berNN] = biterr(x,y)
    
end
toc

