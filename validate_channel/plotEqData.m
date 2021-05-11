%% Proakis Synthetic Channel Equilization Plots

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clc;
clear;
close all;

% read in data
checkData = readmatrix('KallaPointsMMSE.csv');
checkData(:,1) = checkData(:,1)+2.5;
load proakis_NN

% plot
figure()
semilogy(snrPlot,berR(1,:),'*-',snrPlot,berR(3,:),'*-',snrPlot,berR(5,:), '*-',checkData(:,1),checkData(:,2),'*-');
legend('No EQ','RLS EQ','LMLP EQ','From CLEO Paper', 'Location','southwest');
xlim([1 30]);
xlabel('SNR (dB)');
ylabel('BER');
title('SNR vs BER for Different Eqs')
saveas(gcf,'BER_lmlpnnEq.png')