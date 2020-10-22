%% Neural Network for channel equaliztion

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
nb = 2^15; % number of BPSK symbols per vector

% Modulated signal parameters
M = 2; % order of modulation

% Specify a seed for the random number generators to ensure repeatability.
rng(12345)

% Generate a PSK signal
msg = randi([0 M-1],nb,1);
hPSKMod   = comm.PSKModulator(2, ...
    'PhaseOffset',0, ...
    'SymbolMapping','Binary');
hPSKDemod = comm.PSKDemodulator(2, ...
    'PhaseOffset',0, ...
    'SymbolMapping','Binary');
symbols = hPSKMod(msg); % symbols created
PSKConstellation = constellation(hPSKMod)'; % PSK constellation

% Channel parameters
%chnl = [0.227 0.460 0.688 0.460 0.227];% channel impulse response
chnl = [ 0.1 0.2 1 0.2 0.1]; % another channel for testiing
chnlLen = length(chnl); % channel length, in samples
delay = 3;

% Pass the signal through the channel
filtSig = filter(chnl,1,msg);
rxMsg = msg(1:end-(delay-1));
rxSig = filtSig(delay:end);
dec = (rxSig > 0.5);
right = (dec == rxMsg);
top = numel(right)
frac = top / length(rxMsg)
toc
