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
nb = 2^23; % number of BPSK symbols per vector

% Modulated signal parameters
M = 4; % order of modulation

% Specify a seed for the random number generators to ensure repeatability.
rng(12345)
berNN = 1;

while berNN > 0.26
    % Generate a PSK signal
    msg = randi([0 M-1],nb,1);
    symbols = pskmod(msg,M);
    
    % Channel parameters
    %chnl = [0.227 0.460 0.688 0.460 0.227];% channel impulse response
    %chnl = [0.04 -0.05 0.07 -0.21 -0.5 0.72 0.36 0.21 0.03 0.07]; % another channel for testing
    %chnl = [ 0.1 0.2 1 0.2 0.1]; % another channel for testing
    chnl = [0.407 0.815 0.407];
    chnlLen = length(chnl); % channel length, in samples
    
    % Pass the signal through the channel
    filtSig = filter(chnl,1,symbols);
    
    % Add AWGN to the signal
    SNR = 200;
    niosySig = awgn(filtSig,SNR,'measured');
    inputSig = niosySig;
    
    % Use NN
    trainNN = length(symbols)/4;
    perCent = trainNN/length(symbols);
    rx5Sig = nnEq(filtSig,symbols,trainNN);
    bkEst = pskdemod(rx5Sig,M);
    shift = shiftCheck(msg(trainNN:end-1),bkEst, 100)
    shift = 0;
    x = msg(trainNN+29:end-1);
    y = circshift(bkEst,-shift);
    diff = length(x) - length(y);
    diff
    % find BER
    [~,berNN] = biterr(x,y)
    
end
toc

