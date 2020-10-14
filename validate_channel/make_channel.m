% Create Proakis Synthetic Channel

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois

%% Preliminary commands 
close all;
clear all;
clc; 

%% System Paramters
Fs = 1;           % sampling frequency (notional)
nBits = 2048;     % number of BPSK symbols per vector
maxErrs = 200;    % target number of errors at each Eb/No
maxBits = 1e6;    % maximum number of symbols at each Eb/No


% Modulated signal parameters
M = 2;                     % order of modulation
Rs = Fs;                   % symbol rate
nSamp = Fs/Rs;             % samples per symbol
Rb = Rs*log2(M);           % bit rate

% Channel parameters
chnl = [0.227 0.460 0.688 0.460 0.227]';  % channel impulse response
chnlLen = length(chnl);                   % channel length, in samples
EbNo = 0:14;                              % in dB
BER = zeros(size(EbNo));                  % initialize values

% Create BPSK modulator
bpskMod = comm.BPSKModulator;

% Specify a seed for the random number generators to ensure repeatability.
rng(12345)