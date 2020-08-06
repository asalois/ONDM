% QAM investigation

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% message_size = 8;
% m = 2^4;
% data_in = randi(15,1,message_size)
% modded = qammod(data_in,m)
% rec = qamdemod(modded,m)

%% Preliminary commands 

close all;
clear all;
clc; 

%% Set the simulation parameters.
M = 16; % Modulation order
k = log2(M); % Bits/symbol
n = 20000; % Transmitted bits
nSamp = 4; % Samples per symbol
EbNo = 10; % Eb/No (dB)

%% Filter Paramters
span = 10; % Filter span in symbols
rolloff = 0.25; % Rolloff factor


%% Create the raised cosine transmit and receive filters using the previously defined parameters.
txfilter = comm.RaisedCosineTransmitFilter('RolloffFactor',rolloff, ...
    'FilterSpanInSymbols',span,'OutputSamplesPerSymbol',nSamp);

rxfilter = comm.RaisedCosineReceiveFilter('RolloffFactor',rolloff, ...
    'FilterSpanInSymbols',span,'InputSamplesPerSymbol',nSamp, ...
    'DecimationFactor',nSamp);

%% Plot the impulse response of hTxFilter.
fvtool(txfilter,'impulse')