%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generation binary PAM NRZ waveforms
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% clear commands
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; % Clear Command Window
clear all; % clears  workspace
close all; % closes all figures

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% BPSK parameters
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nb=1000000;     % Number of bits
Tb=1;           % Bit period
Rb=1/Tb;        % Bit rate
ns=32;          % Number of samples per bit
fs=ns*Rb;       % Sampling frequency
Ts=1/fs;        % Sampling period
Ttot=nb*Tb;     % Total simulation time
EbNo = 1;       % Signal-to-noise energy ratio per bit Eb/N0 in linear units
m=2;            % Number of levels
SNR = 10*log10(EbNo);% + 10*log10(m) - 10*log10(ns); % Noise SNR per sample in (dB)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate polar pseudo-random bit sequence
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bk=randi([0, 1], 1, nb);
ak=2*(bk-0.5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate a rectangular waveform
% recrectpulse(x,nsamp) applies rectangular pulse shaping to 
% x to produce an output signal having nsamp samples per symbol
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TxSignal = rectpulse(ak,ns);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Alternative method to generate a rectangular waveform
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bk=randi([0, m-1], 1, nb);
ak = pammod(bk,m);
% TxSignal = repelem(ak,ns);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% AWGN channel
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% RxSignal = awgn(TxSignal,SNR,'measured');
% RxSignal = awgn(ak,SNR,'measured');
RxSignal = awgn(ak,SNR);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Filter the received signal w. a matched filter
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% windowSize = ns; 
% h = (1/windowSize)*ones(1,windowSize);
% a = 1;
% 
% outSignal = filter(h,a,RxSignal);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Estimate output bits
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sampledSignal = outSignal(ns-1:ns:end);
bkest = pamdemod(RxSignal,m);
[bk(1:10)' bkest(1:10)']

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Compute the bit error rate (BER)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
peb = 0.5*erfc(sqrt(EbNo));

[numErrors,ber] = biterr(bk(1:nb),bkest(1:nb));

fprintf('\n Bit error rate = %5.2e, based on %d errors\n', ...
    ber,numErrors)

fprintf('\n Theoretical error probability Peb = %5.2e\n', ...
    peb)

