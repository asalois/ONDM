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
%% Signal and Channel Parameters
% System simulation parameters
Fs = 1; % sampling frequency (notional)
nb = 2^20; % number of BPSK symbols per vector
Tb=1; % Bit period
Rb=1/Tb; % Bit rate
fc=2; % Carrier frequency
Tc=1/fc; % Carrier period
nsb=32; % Number of samples per bit
fs=nsb*Rb; % Sampling frequency 
Ts=1/fs; % Sampling period
Ttot=nb*Tb; % Total simulation time
EbNo = 1; % Signal-to-noise energy ratio per bit Eb/N0 in linear units

% Modulated signal parameters
M = 2; % order of modulation

% Specify a seed for the random number generators to ensure repeatability.
rng(12345)

% Generate a PSK signal
msg = randi([0 M-1],nb,1);
symbols = pskmod(msg,M);

% Channel parameters
%chnl = [0.227 0.460 0.688 0.460 0.227];% channel impulse response
chnl = [ 0.1 0.2 1 0.2 0.1]; % another channel for testiing
chnlLen = length(chnl); % channel length, in samples

% Pass the signal through the channel
filtSig = filter(chnl,1,symbols);

% Loop Set up
runTo = 20;
step = 0.5;
runs = runTo/step;
berR = zeros(5,runs);
snrPlot =  1*step:step:runTo;

for i = 1:runs
SNR = i*step; % Noise SNR per sample in (dB)

% Add AWGN to the signal
niosySig = awgn(filtSig,SNR,'measured');
inputSig = niosySig;

%% Use LMS
trainNum = 2000;
taps = 5;
rx1Sig = lmsEq(inputSig,taps,trainNum);
bkEst = pskdemod(rx1Sig,M);

% find BER
delay = 3;
[numErrors,berLMS] = biterr(msg(trainNum:nb-delay),bkEst(trainNum+delay:nb));


%% Use RLS
rx2Sig = rlsEq(inputSig,taps,trainNum);
bkEst = pskdemod(rx2Sig,M);

% find BER
delay = 3;
[numErrors,berRLS] = biterr(msg(trainNum:nb-delay),bkEst(trainNum+delay:nb));


%% Use DFE   
rx3Sig = dfEq(inputSig,taps,trainNum);
bkEst = pskdemod(rx3Sig,M);

% find BER
[numErrors,berDFE] = biterr(msg(trainNum:nb-delay),bkEst(trainNum+delay:nb));

% Theoretical error probability
peb = 0.5*erfc(sqrt(10^SNR/10));

%% run with out LMS Equalizer
rx4Sig = inputSig;
bkEstNoLMS =  pskdemod(rx4Sig,M);

% BER with out LMS
delay = delay -1;
[numErrors,ber] = biterr(msg(trainNum:nb-delay),bkEstNoLMS(trainNum+delay:nb));

% hold values in berR
berR(:,i) = [ber,berLMS,berRLS,berDFE,peb];
end
toc

%%
figure()
plot(snrPlot,berR(1,:),snrPlot,berR(2,:),snrPlot,berR(3,:),snrPlot,berR(4,:),snrPlot,berR(5,:))
legend('No EQ','LMS EQ','RLS EQ','DFE EQ','Theoretical');
xlabel('SNR (dB)');
ylabel('BER');
saveas(gcf,'BER.png');

figure()
semilogy(snrPlot,berR(1,:),snrPlot,berR(2,:),snrPlot,berR(3,:),snrPlot,berR(4,:));
legend('No EQ','LMS EQ','RLS EQ','DFE EQ');
xlabel('SNR (dB)');
ylabel('BER');
saveas(gcf,'BERlogy.png');
