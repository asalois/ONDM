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
n = 20000; % Transmitted bits
nSamp = 4; % Samples per symbol
EbNo = 10; % Eb/No (dB)

%%

message_size = 8;
m = 2^4;
data_in = randi(15,1,message_size)
modded = qammod(data_in,m)
rec = qamdemod(modded,m)