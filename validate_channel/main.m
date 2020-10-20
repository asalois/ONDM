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
nb = 2^19; % number of BPSK symbols per vector
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
symbols = hPSKMod(msg);
PSKConstellation = constellation(hPSKMod)'; % PSK constellation

% Channel parameters
chnl = [0.227 0.460 0.688 0.460 0.227];% channel impulse response
%chnl = [0.25 0.5 0.25]; % another channel for testiing
chnlLen = length(chnl);                   % channel length, in samples

% Pass the signal through the channel
filtSig = filter(chnl,1,symbols);

% Add AWGN to the signal
% niosySig = awgn(filtSig,SNR,'measured');

% variable used in loop below
best = 1;

for i =2:25

% Use LMS     
% rxLMS = lmsEq(niosySig,i,2000);
rxLMS = lmsEq(filtSig,i,2000,PSKConstellation);
rxSig = rxLMS;
bkEst = hPSKDemod(rxSig);

% find BER
[numErrors,ber] = biterr(msg(1:nb),bkEst(1:nb));

% Print BER
% fprintf('\n The number taps = %d', i)
% 
% fprintf('\n Bit error rate = %5.2e, based on %d errors\n', ...
%     ber,numErrors)

    % check of the performance of equalizer improved
    if ber < best
        best = ber;
        besti = i;
        numErrs = numErrors;
    end

end

% print the best result of the loop
fprintf('\n The best number of taps = %d', besti)

fprintf('\n Bit error rate = %5.2e, based on %d errors\n', ...
    best,numErrs)


% Theoretical error probability
peb = 0.5*erfc(sqrt(EbNo));

% run with out LMS Equalizer
rxSig = filtSig;
bkEstNoLMS = pskdemod(rxSig,M);

% BER with out LMS
[numErrors,ber] = biterr(msg(1:nb),bkEstNoLMS(1:nb));

% print results
fprintf('\n No LMS')

fprintf('\n Bit error rate = %5.2e, based on %d errors', ...
    ber,numErrors)

fprintf('\n Theoretical error probability Peb = %5.2e\n', ...
    peb)
toc
