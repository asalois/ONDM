%% Proakis Synthetic Channel Equilization

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clc;
clear;
close all;

%% Signal and Channel Parameters

% System simulation parameters
Fs = 1; % sampling frequency (notional)
nb = 2^15; % number of BPSK symbols per vector
Tb=1; % Bit period
Rb=1/Tb; % Bit rate
fc=2; % Carrier frequency
Tc=1/fc; % Carrier period
nsb=32; % Number of samples per bit
fs=nsb*Rb; % Sampling frequency
Ts=1/fs; % Sampling period
Ttot=nb*Tb; % Total simulation time
EbNo = 1; % Signal-to-noise energy ratio per bit Eb/N0 in linear units
SNR = 10*log10(EbNo); % + 10*log10(m) - 10*log10(ns); % Noise SNR per sample in (dB)

% Modulated signal parameters
M = 2;  % order of modulation

% Specify a seed for the random number generators to ensure repeatability.
rng(12345)

% Generate a PSK signal
msg = randi([0 M-1],nb,1);
symbols = pskmod(msg, M);

% Channel parameters
chnl = [0.227 0.460 0.688 0.460 0.227]';  % channel impulse response
chnlLen = length(chnl);                   % channel length, in samples

% Pass the signal through the channel
filtSig = filter(chnl,1,symbols);

% Make rectangular pulses
%pulseSig = rectpulse(filtSig, nsb);
%pulseSig = rectpulse(symbols, nsb);

span = 10;        % Filter span in symbols
rolloff = 0.75;   % Roloff factor of filter
% Create a square-root, raised cosine filter using the rcosdesign function.

rrcFilter = rcosdesign(rolloff, span, nsb);
txSig = upfirdn(filtSig, rrcFilter, nsb, 1);

% Add AWGN to the signal
niosySig = awgn(txSig,SNR,'measured');
rxSig = niosySig;
%niosySig = filtSig;
rxFiltSig = upfirdn(rxSig,rrcFilter,1,nsb);   % Downsample and filter
rxFiltSig = rxFiltSig(span+1:end-span);  % Account for delay
bkEst = pskdemod(rxFiltSig,M);


%% Print BER
peb = 0.5*erfc(sqrt(EbNo));

[numErrors,ber] = biterr(msg(1:nb),bkEst(1:nb));

fprintf('\n Bit error rate = %5.2e, based on %d errors\n', ...
    ber,numErrors)

fprintf('\n Theoretical error probability Peb = %5.2e\n', ...
    peb)




