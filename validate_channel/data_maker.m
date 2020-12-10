%% Make data for ML

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clc;
clear;
close all;

tic

nb = 2^20;

% Modulated signal parameters
M = 4; % order of modulation

% Specify a seed for the random number generators to ensure repeatability.
rng(12345)

% Generate a PSK signal
msg = randi([0 M-1],nb,1);
%symbols = pskmod(msg,M,pi/4);
symbols = qammod(msg,M);

% Channel parameters
%chnl = [0.227 0.460 0.688 0.460 0.227];% channel impulse response
%chnl = [0.04 -0.05 0.07 -0.21 -0.5 0.72 0.36 0.21 0.03 0.07]; % another channel for testing
% chnl = [ 0.1 0.2 1 0.2 0.1]; % another channel for testing
chnl = [0.407 0.815 0.407];
% chnl = [0 1 0]; % another channel for testing

% Pass the signal through the channel
filtSig = filter(chnl,1,symbols);
shift = 1;
filtSig = filtSig(1+shift:end);
% % Add AWGN to the signal
% SNR = 10;
% niosySig = awgn(filtSig,SNR,'measured');
% inputSig = niosySig;

numSamples = 14;

data = makeInputMat(filtSig,numSamples,nb-shift);
data = data(:,1:end-numSamples);
symbols = circshift(symbols, 0);
target = round([real(symbols(numSamples+1:end-shift)) imag(symbols(numSamples+1:end-shift))],3)';
% target = round(real(symbols(numSamples+1:end-shift)),3)';
diff  = length(data) - length(target)

save('data','data');
save('target','target');

%%
% writematrix(data, 'data.csv');
% writematrix(target, 'target.csv');
% 
prepare_data_for_tensorflow

toc
