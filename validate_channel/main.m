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
nb = 2^20; % number of BPSK symbols per vector
Tb=1; % Bit period
Rb=1/Tb; % Bit rate
fc=2; % Carrier frequency
Tc=1/fc; % Carrier period
nsb=32; % Number of samples per bit
fs=nsb*Rb; % Sampling frequency
Ts=1/fs; % Sampling period
Ttot=nb*Tb; % Total simulation time
EbNo = 10; % Signal-to-noise energy ratio per bit Eb/N0 in linear units
SNR = 10*log10(EbNo); % + 10*log10(m) - 10*log10(ns); % Noise SNR per sample in (dB)

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

% Pass the signal through the channel
filtSig = filter(chnl,1,symbols);

% Add AWGN to the signal
niosySig = awgn(filtSig,SNR,'measured');
inputSig = niosySig;

%% Use LMS     
rxSig = lmsEq(inputSig,5,2000,PSKConstellation);
bkEst = hPSKDemod(rxSig);

% find BER
delay = 3;
[numErrors,berLMS] = biterr(msg(2000:nb-delay),bkEst(2000+delay:nb));

fprintf('LMS Bit error rate = %5.2e, based on %d errors\n', ...
    berLMS,numErrors)

%% Use DFE   
rxSig = dfEq(inputSig,5,2000,PSKConstellation);
bkEst = hPSKDemod(rxSig);

% find BER
[numErrors,berDFE] = biterr(msg(2000:nb-delay),bkEst(2000+delay:nb));

fprintf('DFE Bit error rate = %5.2e, based on %d errors\n', ...
    berDFE,numErrors)

% Theoretical error probability
peb = 0.5*erfc(sqrt(EbNo));

% run with out LMS Equalizer
rxSig = inputSig;
bkEstNoLMS =  hPSKDemod(rxSig);

% BER with out LMS
delay = delay -1;
[numErrors,ber] = biterr(msg(2000:nb-delay),bkEstNoLMS(2000+delay:nb));

% print results

fprintf('No EQ Bit error rate = %5.2e, based on %d errors\n', ...
    ber,numErrors)

fprintf('Theoretical error probability Peb = %5.2e\n\n', ...
    peb)
toc
