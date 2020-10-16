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

% Linear equalizer parameters
nWts = 31;               % number of weights
algType = 'RLS';         % RLS algorithm
forgetFactor = 0.999999; % parameter of RLS algorithm
const = constellation(bpskMod);    % signal constellation

% The RLS update algorithm is used to adapt the equalizer tap weights and
% reference tap is set to center tap.
linEq = comm.LinearEqualizer('Algorithm',algType, ...
    'ForgettingFactor',forgetFactor, ...
    'NumTaps',nWts, ...
    'Constellation',const, ...
    'ReferenceTap',round(nWts/2), ...
    'TrainingFlagInputPort',true);

%% Linear Equalizer
% Run the linear equalizer, and plot the equalized signal spectrum, the
% BER, and the burst error performance for each data block. Note that as
% the Eb/No increases, the linearly equalized signal spectrum has a
% progressively deeper null. This highlights the fact that a linear
% equalizer must have many more taps to adequately equalize a channel with
% a deep null. Note also that the errors occur with small inter-error
% intervals, which is to be expected at such a high error rate.
%
% See <matlab:openExample('comm/BERPerformanceOfDifferentEqualizerExample','supportingFile','eqber_adaptive.m') eqber_adaptive.m> for a listing of the simulation code for the
% adaptive equalizers.
firstRun = true;  % flag to ensure known initial states for noise and data
eqType = 'linear';
eqber_adaptive;


