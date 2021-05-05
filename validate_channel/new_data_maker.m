%% Make data for NN

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois Summer 2021

% prelim comands
clc;
clear;
close all;

tic

nb = 2^10 +1;

% Modulated signal parameters
M = 4; % order of modulation

% Generate random symbols
msg = randi([0 M-1],nb,1);
symbols = qammod(msg,M);

% Channel parameters
chnl = [0.407 0.815 0.407];
% chnl = [0 1 0]; % another channel for testing

% Pass the signal through the channel
filtSig = filter(chnl,1,symbols);
shift = 1;
filtSig = filtSig(1+shift:end);
symbols = symbols(1:end-shift);

% % Add AWGN to the signal
% SNR = 10;
% niosySig = awgn(filtSig,SNR,'measured');
% inputSig = niosySig;

data = filtSig';
target = round([real(symbols) imag(symbols)],3)';

save('data','data');
save('target','target');

toc
