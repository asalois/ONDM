% QAM-16 with polarization mode dispersion

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois

%% Preliminary commands 
close all;
clear all;
clc; 

%% Simulation parameters
% Signal parameters
M = 4; % Modulation order
k = log2(M); % Bits/symbol
n = 5000*k; % Transmitted bits
nSamp = 4; % Samples per symbol
SNR = 20; % Signal to noise ratio (dB)

% Fiber parameters
num_modes = 1; % number of modes that includes polarizations (smf w/ x y)
num_fibers = 1; % number of fibers to simulate
num_fiber_sections = 100; %number of fiber sections
tau = 1/100000; % Differential group delay (DGD) between x,y SOPs per segment

% Launch conditions
phi = pi/4; % Phase difference between x,y SOPs 
launch_jones_vector = [cos(phi); sin(phi)]; % Launch Jones vector


%% Filter Paramters
span = 50; % Filter span in symbols
rolloff = 0.25; % Rolloff factor


%% Create the raised cosine transmit and receive filters using the previously defined parameters.
txfilter = comm.RaisedCosineTransmitFilter('RolloffFactor',rolloff, ...
    'FilterSpanInSymbols',span,'OutputSamplesPerSymbol',nSamp);

rxfilter = comm.RaisedCosineReceiveFilter('RolloffFactor',rolloff, ...
    'FilterSpanInSymbols',span,'InputSamplesPerSymbol',nSamp, ...
    'DecimationFactor',nSamp);


%% Make Tx signal
% Calculate the delay through the matched filters. 
% The group delay is half of the filter span through one filter and is, 
% therefore, equal to the filter span for both filters. 
% Multiply by the number of bits per symbol to get the delay in bits.
filtDelay = k*span; 
errorRate = comm.ErrorRate('ReceiveDelay',filtDelay); % set error rate
x = randi([0 1],n,1); % random bit stream 
modSig = qammod(x, M,'InputType','bit'); % modulate
txSig = txfilter(modSig); % filter modulted signal

%% Tx spectrum
nfft = 2^nextpow2(length(txSig));
Y = fft(txSig,nfft); %  fft
G = fftshift(Y); % zero-centered spectrum
f = ((-nfft/2+1/2):(nfft/2-1/2))*nSamp; % zero-centered frequency range


