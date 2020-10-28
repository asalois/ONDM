%% Neural Network for channel equaliztion

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clc;
% clear;
% close all;

% time simulation
tic
%% Signal and Channel Parameters
% System simulation parameters
Fs = 1; % sampling frequency (notional)
nb = 2^16; % number of BPSK symbols per vector
SNR = 100;

% Modulated signal parameters
M = 2; % order of modulation

% Specify a seed for the random number generators to ensure repeatability.
rng(12345)

% Generate a PSK signal
msg1 = randi([0 M-1],nb,1);
msg2 = randi([0 M-1],nb,1);
% hPSKMod   = comm.PSKModulator(2, ...
%     'PhaseOffset',0, ...
%     'SymbolMapping','Binary');
% hPSKDemod = comm.PSKDemodulator(2, ...
%     'PhaseOffset',0, ...
%     'SymbolMapping','Binary');
% symbols = hPSKMod(msg); % symbols created
% PSKConstellation = constellation(hPSKMod)'; % PSK constellation

% Channel parameters
%chnl = [0.227 0.460 0.688 0.460 0.227];% channel impulse response
chnl = [ 0.1 0.2 1 0.2 0.1]; % another channel for testiing
delay = 3;

% Pass the signal through the channel
rxMsg = msg1(1:end-(delay-1));
rxSig = channel(msg1,chnl,SNR,delay);

% check if simple descion will work
% dec = (rxSig > 0.5);
% right = (dec == rxMsg);
% top = numel(right);
% frac = top / length(rxMsg)

load('nn_results.mat')
nnet = results.net;
rxMsgCheck = msg2(1:end-(delay-1));
rxSigCheck = channel(msg2,chnl,SNR,delay);
x1 = rxSigCheck(6:end)';
xi1 = rxSigCheck(1:6)';
x2 = rxMsgCheck(6:end)';
xi2 = rxMsgCheck(1:6)';

[y1,xf1,xf2] = myNeuralNetworkFunctionMatrixNiose(x1,x2,xi1,xi2);
right = (y1 == x2);
top = numel(right);
frac = top / length(x2)
y = (y1 -0.5)*2;
scatterplot(y(end-2000:end))

toc
