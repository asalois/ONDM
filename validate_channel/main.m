%% Proakis Synthetic Channel Equilization

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clc;
% clear;
close all;
tic

checkData = readmatrix('KallaPointsMMSE.csv');
checkData(:,1) = checkData(:,1)+2.5;

%% Signal and Channel Parameters
% System simulation parameters
Fs = 1; % sampling frequency (notional)
nb = 2^21; % number of BPSK symbols per vector
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
filtSig = filtSig(2:end);

% Loop Set up
runTo = 30;
step = 1;
runs = runTo/step;
berR = zeros(7,runs);
snrPlot =  1*step:step:runTo;

for i = [14 20:30]
    SNR = i*step % Noise SNR per sample in (dB)
    
    % Add AWGN to the signal
    niosySig = awgn(filtSig,SNR,'measured');
    inputSig = niosySig;
    
    %% Use LMS
    trainNum = nb/16;
    taps = 4;
    rx1Sig = lmsEq(inputSig,taps,trainNum);
    bkEst = qamdemod(rx1Sig,M);
    
    % find BER
    delay = 2;
    [~,berLMS] = biterr(msg(trainNum:end-delay),bkEst(trainNum+delay-1:end));
    
    
    %% Use RLS
    rx2Sig = rlsEq(inputSig,taps,trainNum);
    bkEst = qamdemod(rx2Sig,M);
    
    % find BER
    [~,berRLS] = biterr(msg(trainNum:end-delay),bkEst(trainNum+delay-1:end));
    
    
    %% Use DFE
    rx3Sig = dfEq(inputSig,taps,trainNum);
    bkEst = qamdemod(rx3Sig,M);
    
    % find BER
    [~,berDFE] = biterr(msg(trainNum:end-delay),bkEst(trainNum+delay-1:end));
    
    %% Use NN
    Eqnet = lmlpnnEq(SNR,100);
    numSamples = 14;
    data = makeInputMat(inputSig,numSamples);
    data = data(:,1:end-numSamples);
    output = Eqnet(data);
    output = [output(1,:) + output(2,:)*1i];
    bkEst = qamdemod(output,M);
    x = msg(1+numSamples:end-1);
    y = bkEst(1:end)';
    [~,berNN] = biterr(x,y);
    
    %% Use Deep NN
    deepnet = deepnnEq(SNR,1e3,50);
    numSamples = 4;
    data = makeInputMat(inputSig,numSamples);
    data = data(:,1:end-numSamples);
    output = predict(deepnet, data')';
    output = [output(1,:) + output(2,:)*1i];
    bkEst = qamdemod(output,M);
    x = msg(1+numSamples:end-1);
    y = bkEst(1:end)';
    [~,berDNN] = biterr(x,y)
    
    %% run with out LMS Equalizer
    rx4Sig = inputSig;
    bkEstNoLMS =  qamdemod(rx4Sig,M);
    
    % BER with out LMS
    delay = delay -1;
    [~,ber] = biterr(msg(trainNum:end-delay),bkEstNoLMS(trainNum+delay-1:end));
    
    % Theoretical error probability
    peb = 0.5*erfc(sqrt(10^SNR/10));
    
    % hold values in berR
    berR(:,i) = [ber,berLMS,berRLS,berDFE,berNN,berDNN,peb]';
end

%% Plot SNR vs BER
figure()
semilogy(snrPlot,berR(1,:),'*-',snrPlot,berR(2,:),'*-',snrPlot,berR(3,:),'*-',...
    snrPlot,berR(4,:), '*-',snrPlot,berR(5,:), '*-',snrPlot,berR(6,:),'*-'...
    ,checkData(:,1),checkData(:,2),'*-');
legend('No EQ','LMS EQ','RLS EQ','DFE Eq','LMLP EQ','Deep NN','From CLEO Paper', 'Location','southwest');
xlim([1 30]);
xlabel('SNR (dB)');
ylabel('BER');
title('SNR vs BER for Different Eqs')
saveas(gcf,'BER_lmlpnnEq.png')
save('proakis_NN_next', 'berR', 'snrPlot', 'nb', 'chnl', 'M') 
toc
