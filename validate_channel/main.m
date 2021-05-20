%% Proakis Synthetic Channel Equilization

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clc;
clear;
close all;
tic

%% Signal and Channel Parameters
nb = 2^21; % number of symbols per vector

% Specify a seed for the random number generators to ensure repeatability.
rng(12345)

% Loop Set up
runTo = 30;
step = 1;
runs = runTo/step;
berR = zeros(7,runs);
snrPlot =  1*step:step:runTo;

for i = 1:30
    SNR = i*step % Noise SNR per sample in (dB)

    % hold values in berR
    berR(:,i) = oneSNRset(SNR,nb,10,10);
end

save('proakis_NN_next', 'berR', 'snrPlot', 'nb', 'chnl', 'M')
toc
