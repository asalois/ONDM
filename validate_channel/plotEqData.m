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
snrPlot = 1:25;
load berRDNN
% load proakis_NN
% newBerR = berR;
% load berR118
% newBerR = newBerR + berR;
% berR = newBerR;

% plot
figure()
semilogy(snrPlot,berR(1,:),'*-',snrPlot,berR(3,:),'*-',snrPlot,berR(5,:), '*-',snrPlot,berR(6,:), '*-',checkData(:,1),checkData(:,2),'*-');
legend('No EQ','RLS EQ','LMLP NN EQ','Deep NN EQ','LMLP from CLEO', 'Location','southwest');
xlim([5 25]);
xlabel('SNR (dB)');
ylabel('BER');
title('SNR vs BER for Different Eqs')
saveas(gcf,'BER_lmlpnnEq.png')