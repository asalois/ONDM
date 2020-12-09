%% Proakis Synthetic Channel Equilization

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clc;
clear;
close all;

% time simulation
tic

checkData = readmatrix('KallaPointsMMSE.csv');
%% Signal and Channel Parameters
% System simulation parameters
Fs = 1; % sampling frequency (notional)
nb = 2^20; % number of BPSK symbols per vector
% Tb=1; % Bit period
% Rb=1/Tb; % Bit rate
% fc=2; % Carrier frequency
% Tc=1/fc; % Carrier period
% nsb=32; % Number of samples per bit
% fs=nsb*Rb; % Sampling frequency
% Ts=1/fs; % Sampling period
% Ttot=nb*Tb; % Total simulation time
% EbNo = 1; % Signal-to-noise energy ratio per bit Eb/N0 in linear units

% Modulated signal parameters
M = 4; % order of modulation

% Specify a seed for the random number generators to ensure repeatability.
rng(12345)

% Generate a PSK signal
msg = randi([0 M-1],nb,1);
symbols = qammod(msg,M);

% Channel parameters
%chnl = [0.227 0.460 0.688 0.460 0.227];% channel impulse response
%chnl = [0.04 -0.05 0.07 -0.21 -0.5 0.72 0.36 0.21 0.03 0.07]; % another channel for testing
%chnl = [ 0.1 0.2 1 0.2 0.1]; % another channel for testing
chnl = [0.407 0.815 0.407];
chnlLen = length(chnl); % channel length, in samples

% Pass the signal through the channel
filtSig = filter(chnl,1,symbols);

% Loop Set up
runTo = 22;
step = 0.5;
runs = runTo/step;
berR = zeros(6,runs);
snrPlot =  1*step:step:runTo;

for i = 1:runs
    SNR = i*step % Noise SNR per sample in (dB)
%     SNR = 30;
    
    % Add AWGN to the signal
    niosySig = awgn(filtSig,SNR,'measured');
    inputSig = niosySig;
    
    %% Use LMS
    trainNum = nb/8;
    taps = 4;
    rx1Sig = lmsEq(inputSig,taps,trainNum);
    bkEst = qamdemod(rx1Sig,M);
    
    % find BER
    delay = 2;
    [~,berLMS] = biterr(msg(trainNum:nb-delay),bkEst(trainNum+delay:nb));
    
    
    %% Use RLS
%     taps = 4;
    rx2Sig = rlsEq(inputSig,taps,trainNum);
    bkEst = qamdemod(rx2Sig,M);
    
    % find BER
    [~,berRLS] = biterr(msg(trainNum:nb-delay),bkEst(trainNum+delay:nb));
    
    
    %% Use DFE
    rx3Sig = dfEq(inputSig,taps,trainNum);
    bkEst = qamdemod(rx3Sig,M);
    
    % find BER
    [~,berDFE] = biterr(msg(trainNum:nb-delay),bkEst(trainNum+delay:nb));
    
    %% Use NN
    w = load('w.mat');
    z = w.w;
    rx5Sig = filter(z,1,inputSig);
    bkEst = qamdemod(rx5Sig,M);
    % shift = shiftCheck(bkEst,msg,2^8)
    [~,berNN] = biterr(bkEst,msg)

    %% run with out LMS Equalizer
    rx4Sig = inputSig;
    bkEstNoLMS =  qamdemod(rx4Sig,M);
    
    % BER with out LMS
    delay = delay -1;
    [~,ber] = biterr(msg(trainNum:nb-delay),bkEstNoLMS(trainNum+delay:nb));
    
    % Theoretical error probability
    peb = 0.5*erfc(sqrt(10^SNR/10));
    
    % hold values in berR
    berR(:,i) = [ber,berLMS,berRLS,berDFE,berNN,peb];
end
toc

%%
% figure()
% hold on
% % plot(snrPlot,berR(1,:),'*-',snrPlot,berR(2,:),'*-',snrPlot,berR(3,:),'*-',snrPlot,berR(4,:),'*-',snrPlot,berR(5,:),'*-',snrPlot,berR(6,:),'*-')
% plot(snrPlot,berR(1,:),'*-',snrPlot,berR(2,:),'*-',snrPlot,berR(3,:),'*-',snrPlot,berR(4,:),'*-')
% plot(checkData(:,1),checkData(:,2),'*-')
% hold off
% legend('No EQ','LMS EQ','RLS EQ','DFE EQ', 'From Paper');
% xlim([5 20]);
% xlabel('SNR (dB)');
% ylabel('BER');
% saveas(gcf,'BER.png');

figure()
semilogy(snrPlot,berR(1,:),'*-',snrPlot,berR(2,:),'*-',snrPlot,berR(3,:),'*-',snrPlot,berR(5,:),'*-',checkData(:,1),checkData(:,2),'*-');
legend('No EQ','LMS EQ','RLS EQ','NN EQ','From Paper');
xlim([5 20]);
xlabel('SNR (dB)');
ylabel('BER');
% saveas(gcf,'BERlogy.png');
