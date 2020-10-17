%% Proakis Synthetic Channel Equilization

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois
% Based on BER example from Mathworks

% prelim comands
clc;
clear;
close all;

%% Signal and Channel Parameters
% Set parameters related to the signal and channel. Use BPSK without any
% pulse shaping, and a 5-tap real-valued symmetric channel impulse
% response. (See section 10.2.3 of Digital Communications by J. Proakis,
% 4th Ed., for more details on the channel.)  Set initial states of data
% and noise generators. Set the Eb/No range.

% System simulation parameters
Fs = 1;           % sampling frequency (notional)
nBits = 4096;     % number of BPSK symbols per vector
maxErrs = 200;    % target number of errors at each Eb/No
maxBits = 1e7;    % maximum number of symbols at each Eb/No

% Modulated signal parameters
M = 2;                     % order of modulation
Rs = Fs;                   % symbol rate
nSamp = Fs/Rs;             % samples per symbol
Rb = Rs*log2(M);           % bit rate

% Channel parameters
chnl = [0.227 0.460 0.688 0.460 0.227]';  % channel impulse response
chnlLen = length(chnl);                   % channel length, in samples
EbNo = 0:24;                              % in dB
BER = zeros(size(EbNo));                  % initialize values

% Specify a seed for the random number generators to ensure repeatability.
rng(12345)

rxSig = sigGen(M,nBits,chnl,EbNo(1))
