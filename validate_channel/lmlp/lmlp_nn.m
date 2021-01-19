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


% Generate a PSK signal
nb = 2^20;
M = 4; % modulation order
msg = randi([0 M-1],nb,1);
symbols = qammod(msg,M);

% Channel parameters
chnl = [0.407 0.815 0.407];

% Pass the signal through the channel
filtSig = filter(chnl,1,symbols);
shift = 1;
filtSig = filtSig(1+shift:end);

numSamples = 14;

data = makeInputMat(filtSig,numSamples,nb-shift);
data = data(:,1:end-numSamples);
symbols = circshift(symbols, 0);
target = round([real(symbols(numSamples+1:end-shift)) imag(symbols(numSamples+1:end-shift))],3)';
test = 2^10;

%%
% load('Eqnet_test.mat');
% Define network
hLayers = 70; % hidden layer size
Eqnet = fitnet(hLayers,'traingd'); % make a fitnet
Eqnet.layers{1}.transferFcn = 'purelin'; % have the actuvation be linear
Eqnet.layers{2}.transferFcn = 'purelin'; % have the actuvation be linear

Eqnet.trainParam.showWindow=false;
Eqnet.trainParam.showCommandLine=true;
Eqnet.trainParam.epochs=1000;
%
% Train the Network
[Eqnet,TT] = train(Eqnet,data(:,1:end-test),target(:,1:end-test),'useGPU', 'yes'); % use when gpu
% [Eqnet,TT] = train(Eqnet,data(:,1:end-test),target(:,1:end-test)); % use when no gpu and small data
% [Eqnet,TT] = train(Eqnet,data(:,1:end-test),target(:,1:end-test),'useParallel','yes'); % use when no gpu and large data
% [Eqnet,TT] = train(Eqnet,data(:,1:end-test),target(:,1:end-test),'useGPU', 'yes','useParallel','yes'); % use when gpu

%% Test the Network
output = Eqnet(data(:,end-test:end));
output = [output(1,:) + output(2,:)*1i];
msg_test = qamdemod(output,4);

%%
msg = qamdemod([target(1,end-test:end) + target(2,end-test:end)*1i],M); 
[num_wrong,berNN] = biterr(msg,msg_test)
%save('Eqnet_test','Eqnet')
x = cell2mat(Eqnet.LW(2));
x = x';
b = cell2mat(Eqnet.b(1));
z = [x(:,1)+b x(:,2)+b];
b = cell2mat(Eqnet.b(2));
z = [x(:,1)+b(1) x(:,2)+b(2)];
w = [x(:,1) + x(:,2)*1i];
%save('w','w');
%main
toc

