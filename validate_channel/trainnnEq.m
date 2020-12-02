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
%% Signal and Channel Parameters
% System simulation parameters
Fs = 1; % sampling frequency (notional)
nb = 2^15; % number of symbols per vector

% Modulated signal parameters
M = 4; % order of modulation

% Specify a seed for the random number generators to ensure repeatability.
rng(12345)
berNN = 1;

while berNN > 0.49
    % Generate a signal
    msg = randi([0 M-1],nb,1);
    symbols = qammod(msg,M);
    
    % Channel parameters
    %chnl = [0.227 0.460 0.688 0.460 0.227];% channel impulse response
    %chnl = [0.04 -0.05 0.07 -0.21 -0.5 0.72 0.36 0.21 0.03 0.07]; % another channel for testing
    chnl = [0 1 0]; % another channel for testing
    %chnl = [0.407 0.815 0.407];
%     chnlLen = length(chnl); % channel length, in samples
    
    % Pass the signal through the channel
    filtSig = filter(chnl,1,symbols);
    
    % Add AWGN to the signal
    SNR = 200;
    niosySig = awgn(filtSig,SNR,'measured');
    inputSig = niosySig;
    
    % Use NN
    trainNN = length(symbols)/2;
    perCent = trainNN/length(symbols);
%     symbols = circshift(symbols,-2);
    rx5Sig = nnEq(filtSig,symbols,trainNN);
    bkEst = qamdemod(rx5Sig,M);
%     shift = shiftCheck(msg(trainNN:end-1),bkEst, 2^8)
    shift = 0;
    x = msg(trainNN:end-1);
    y = circshift(bkEst,shift);
    diff = length(x) - length(y);
    diff
    % find BER
    [~,berNN] = biterr(x,y)
    
end
toc

