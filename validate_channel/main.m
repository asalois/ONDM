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
runTo = 25;
step = 1;
runs = runTo/step;
berR = zeros(7,runs);
snrPlot =  1*step:step:runTo;

for i = 5:25
    SNR = i*step % Noise SNR per sample in (dB)

    % hold values in berR
    berR(:,i) = oneSNRset(SNR,nb,2.5e3,100);
end

save('proakis_NN_next', 'berR', 'snrPlot', 'nb', 'chnl', 'M')
toc
