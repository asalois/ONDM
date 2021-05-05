function [train_data,target] = get_train_data(pow)
%get_train_data makes training data and target data based on channel
%   Detailed explanation goes here

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois Summer 2021

nb = 2^pow +1;
M = 4; % order of modulation

% Generate random symbols
msg = randi([0 M-1],nb,1);
symbols = qammod(msg,M);

% Channel parameters
chnl = [0.407 0.815 0.407];
% chnl = [0 1 0]; % another channel for testing

% Pass the signal through the channel
filtSig = filter(chnl,1,symbols);

% cut head and tail
shift = 1;
filtSig = filtSig(1+shift:end);
symbols = symbols(1:end-shift);

% % Add AWGN to the signal
% SNR = 10;
% niosySig = awgn(filtSig,SNR,'measured');
% inputSig = niosySig;
samples =14;
train_data = makeInputMat(filtSig,samples);
train_data = train_data(:,1:end-samples);
symbols = symbols(1+samples:end);
target = round([real(symbols) imag(symbols)],3)';
end

