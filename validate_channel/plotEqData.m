%% Proakis Synthetic Channel Equilization Plots

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clc;
clear;
close all;

% read in data
checkData = readmatrix('data_cleo.csv')';
no_eq_cleo = checkData(1:2,:);
lmlp_eq_cleo = checkData(3:4,:);
deep_eq_cleo = checkData(5:6,:);
snrPlot = 1:30;
load berDNNTF
load proakis_NN
% load proakis_NN_next
% newBerR = berR;
% load berR118
% newBerR = newBerR + berR;
% berR = newBerR;
%%
% plot
figure()
semilogy(snrPlot,berR([1 5 6],:),'*-',...
    snrPlot,ber(1:30),'-*',...
    no_eq_cleo(1,:),no_eq_cleo(2,:),'-*',...
    lmlp_eq_cleo(1,:),lmlp_eq_cleo(2,:),'-*',...
    deep_eq_cleo(1,:),deep_eq_cleo(2,:),'-*');

% checkCheckData(:,1),checkCheckData(:,2),'*-',...
%     checkCheckData(:,3),checkCheckData(:,4),'*-',...
%     checkCheckData(:,5),checkCheckData(:,6),'*-',...
%     checkData(:,1),checkData(:,2),'*-',...
%     checkData(:,3),checkData(:,4),'*-',...

legend('No EQ','LMLP EQ','DeepNN EQ','DeepNN from Python',...
    'No EQ from CLEO','LMLP From CLEO','Deep NN From CLEO',...
    'Location','southwest');

xlim([5 30]);
xlabel('SNR (dB)');
ylabel('BER');
title('SNR vs BER for Different Eqs')
saveas(gcf,'BER_nnEqs.png')

%%
% other plot
% figure()
% semilogy(snrPlot,berR(1,:),'*-',snrPlot,berR(2,:),'*-', snrPlot,berR(4,:), '*-'...
%     ,snrPlot,berR(5,:), '*-',snrPlot,berR(6,:),'*-',...
%     checkData(:,1),checkData(:,2),'*-',checkData(:,3),checkData(:,4),'*-');
% legend('No EQ','LMS EQ','DFE Eq','LMLP EQ','DeepNN EQ','LMLP From CLEO Paper',...
%     'Deep NN From CLEO Paper','Location','southwest');