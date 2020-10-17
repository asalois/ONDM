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
nb = 10; % number of BPSK symbols per vector
Tb=1; % Bit period
Rb=1/Tb; % Bit rate
fc=2; % Carrier frequency
Tc=1/fc; % Carrier period
nsb=32; % Number of samples per bit
fs=nsb*Rb; % Sampling frequency
Ts=1/fs; % Sampling period
Ttot=nb*Tb; % Total simulation time


% Modulated signal parameters
M = 2;                     % order of modulation

% Channel parameters
chnl = [0.227 0.460 0.688 0.460 0.227]';  % channel impulse response
chnlLen = length(chnl);                   % channel length, in samples
EbNo = 0:24;                              % in dB

% Specify a seed for the random number generators to ensure repeatability.
rng(12345)

% Generate a PSK signal
msg = randi([0 M-1],nb,1);
symbols = pskmod(msg, M);

% Pass the signal through the channel
%filtSig = filter(chnl,1,symbols);

% Make rectangular pulses
%pulseSig = rectpulse(filtSig, nsb);
pulseSig = rectpulse(symbols, nsb);

% Add AWGN to the signal
%SNR = EbNo(1) + 10*log10(Rb/fs);
%niosySig = awgn(pulseSig,SNR,'measured');
niosySig = pulseSig;
t=0:Ts:Ttot-Ts; % Sampling the time axis
carrier=sin(2*pi*fc*t); % Generate the carrier

figure()
stem(real(niosySig))

figure()
plot(t,carrier)

figure()
plot(t,real(niosySig.*carrier))


