function out = oneSNRset(SNR,nb,chunks,ep)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Add AWGN to the signal

%% Proakis Synthetic Channel Equilization

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
% clc;
% clear;
% close all;
tic

% Modulated signal parameters
M = 4; % order of modulation

% Specify a seed for the random number generators to ensure repeatability.
rng(12345)

% Generate a PSK signal
msg = randi([0 M-1],nb,1);
symbols = qammod(msg,M);

% Channel parameters
chnl = [0.407 0.815 0.407];

% Pass the signal through the channel
filtSig = filter(chnl,1,symbols);
filtSig = filtSig(2:end);
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
Eqnet = lmlpnnEq(SNR,floor(chunks/10));
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
deepnet = deepnnEq(SNR,chunks,ep);
numSamples = 4;
data = makeInputMat(inputSig,numSamples);
data = data(:,1:end-numSamples);
output = predict(deepnet, data')';
output = [output(1,:) + output(2,:)*1i];
bkEst = qamdemod(output,M);
x = msg(1+numSamples:end-1);
y = bkEst(1:end)';
[~,berDNN] = biterr(x,y);

%% run with out LMS Equalizer
rx4Sig = inputSig;
bkEstNoLMS =  qamdemod(rx4Sig,M);

% BER with out LMS
delay = delay -1;
[~,ber] = biterr(msg(trainNum:end-delay),bkEstNoLMS(trainNum+delay-1:end));

% Theoretical error probability
peb = 0.5*erfc(sqrt(10^SNR/10));

out = [ber,berLMS,berRLS,berDFE,berNN,berDNN,peb]';
toc

end

