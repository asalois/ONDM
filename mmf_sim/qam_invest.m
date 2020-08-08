% QAM investigation

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois

%% Preliminary commands 

close all;
clear all;
clc; 

%% Set the simulation parameters.
M = 16; % Modulation order
k = log2(M); % Bits/symbol
n = 2000; % Transmitted bits
nSamp = 4; % Samples per symbol
EbNo = 10; % Eb/No (dB)

phi = pi/4; % Phase difference between x,y SOPs 
launch_jones_vector = [cos(phi); sin(phi)]; % Launch Jones vector

%% Filter Paramters
span = 100; % Filter span in symbols
rolloff = 0.25; % Rolloff factor


%% Create the raised cosine transmit and receive filters using the previously defined parameters.
txfilter = comm.RaisedCosineTransmitFilter('RolloffFactor',rolloff, ...
    'FilterSpanInSymbols',span,'OutputSamplesPerSymbol',nSamp);

rxfilter = comm.RaisedCosineReceiveFilter('RolloffFactor',rolloff, ...
    'FilterSpanInSymbols',span,'InputSamplesPerSymbol',nSamp, ...
    'DecimationFactor',nSamp);

%% Plot the impulse response of hTxFilter.
%fvtool(txfilter,'impulse')

%% 
% Calculate the delay through the matched filters. 
% The group delay is half of the filter span through one filter and is, 
% therefore, equal to the filter span for both filters. 
% Multiply by the number of bits per symbol to get the delay in bits.
filtDelay = k*span; 
errorRate = comm.ErrorRate('ReceiveDelay',filtDelay); % set error rate
x = randi([0 1],n,1); % random bit stream 
modSig = qammod(x,M,'InputType','bit'); % modulate
txSig = txfilter(modSig); % filter modulted signal

%% Plot 
% eyediagram(txSig(1:1000),nSamp) % show an eye diagram

%% send through fiber
% n= nextpow2(length(txSig));
% nfft = 2^n;
% Y = fft(txSig,nfft); %  fft
% G = fftshift(Y); % zero-centered spectrum
% 
% out_pulse = zeros(2,nfft);
% for k = 1:nfft
%     out_pulse(:,k) = G(k)* eye(2) * launch_jones_vector;
% end
% 
% % Output electric fields x,y SOPs
% ex = ifft(fftshift(out_pulse(1,:)));
% ey = ifft(fftshift(out_pulse(2,:)));


%% Calc SNR
% SNR = EbNo + 10*log10(k) - 10*log10(nSamp);
% noisySig = awgn(txSig,SNR,'measured');

%%
rxSig = rxfilter(txSig);
scatterplot(rxSig(400:500))

%% BER
% z = qamdemod(rxSig,M,'OutputType','bit');
% 
% errStat = errorRate(x,z);
% fprintf('\nBER = %5.2e\nBit Errors = %d\nBits Transmitted = %d\n',...
%     errStat)