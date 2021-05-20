%% Proakis Synthetic Channel Equilization for Hyalite HPC
function main_hpc(SNR)
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

ber = oneSNRset(SNR,nb,10,10)';
ber = [SNR ber];
filename = sprintf('SNR_%02d.csv',SNR);
csvwrite(filename,M)

toc
