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
checkData(:,1) = checkData(:,1)+0;
checkData(:,3) = checkData(:,3)+0;
snrPlot = 1:30;
% load berRDNN
load proakis_NN
% load proakis_NN_next
% newBerR = berR;
% load berR118
% newBerR = newBerR + berR;
% berR = newBerR;

% plot
figure()
% semilogy(snrPlot,berR(1,:),'*-',snrPlot,berR(2,:),'*-', snrPlot,berR(4,:), '*-'...
%     ,snrPlot,berR(5,:), '*-',snrPlot,berR(6,:),'*-',...
%     checkData(:,1),checkData(:,2),'*-',checkData(:,3),checkData(:,4),'*-');
% legend('No EQ','LMS EQ','DFE Eq','LMLP EQ','DeepNN EQ','LMLP From CLEO Paper',...
%     'Deep NN From CLEO Paper','Location','southwest');
semilogy(snrPlot,berR(1,:),'*-',...
    snrPlot,berR(5,:), '*-',snrPlot,berR(6,:),'*-',...
    checkData(:,1),checkData(:,2),'*-',checkData(:,3),checkData(:,4),'*-');
legend('No EQ','LMLP EQ','DeepNN EQ','LMLP From CLEO Paper',...
    'Deep NN From CLEO Paper','Location','southwest');
xlim([5 30]);
xlabel('SNR (dB)');
ylabel('BER');
title('SNR vs BER for Different Eqs')
saveas(gcf,'BER_nnEqs.png')