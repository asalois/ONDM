% Matlab implentmation of adaptive equilzers using Com toolbox

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois based on https://www.mathworks.com/help/comm/ug/adaptive-equalizers.html#a1049736245

%% prelim comands
clc;
clear;
close all;

for i = 1:10
% system setup
M = 2; % mod depth
Rs = 1e6; % symbol rate ?
fd = 10;  % frequency shift delta
numTrainSymbols = 200;
numDataSymbols = 1800;
SNR = 20; % signal to Noise Ratio
trainingSymbols = pskmod(randi([0 M-1],numTrainSymbols,1),M,pi/4);

% eq setup
lineq = comm.LinearEqualizer('Algorithm','LMS', ...
    'NumTaps',8,'ReferenceTap',3,'StepSize',0.01);


b = randi([0 M-1],numDataSymbols,1); % random bit stream
dataSym = pskmod(b,M,pi/4); % psk modulate
packet = [trainingSymbols; dataSym]; % packet
stream = repmat(packet,10,1); % bit stream of packets
tx = (0:length(stream)-1)'/Rs;
channel = exp(1i*2*pi*fd*tx); % create channel
rx = awgn(stream.*channel,SNR); % make it niosy

release(lineq)
lineq.AdaptAfterTraining = false;

[y,err] = lineq(rx,trainingSymbols);

% % plot results 
% figure()
% subplot(2,1,1)
% plot(tx, unwrap(angle(channel)))
% xlabel('Time (sec)')
% ylabel('Channel Angle (rad)')
% title('Angular Error Over Time')
% subplot(2,1,2)
% plot(abs(err))
% xlabel('Symbols')
% ylabel('Error Magnitude')
% grid on
% title('Time-Varying Channel Without Retraining')
% scatterplot(y)


%perodic training
spp = 200; % Symbols per packet to proceess
release(lineq)
lineq.TrainingFlagInputPort = true;
symbolCnt = 0;
numProcess = length(rx)/spp;
trainFlag = true;
trainingPeriod = 2000; % this should be about the length of packet
eVec = zeros(size(rx));
yVec = zeros(size(rx));
for p=1:numProcess
    [yVec((p-1)*spp+1:p*spp,1),eVec((p-1)*spp+1:p*spp,1)] = ...
        lineq(rx((p-1)*spp+1:p*spp,1),trainingSymbols,trainFlag);
    symbolCnt = symbolCnt + spp;
    if symbolCnt >= trainingPeriod
        trainFlag = true;
        symbolCnt = 0;
    else
        trainFlag = false;
    end
end

% plot results
% figure
% subplot(2,1,1)
% plot(tx, unwrap(angle(channel)))
% xlabel('t (sec)')
% ylabel('Channel Angle (rad)')
% title('Angular Error Over Time')
% subplot(2,1,2)
% plot(abs(eVec))
% xlabel('Symbols')
% ylabel('Error Magnitude')
% grid on
% title('Time-Varying Channel With Retraining')
scatterplot(yVec)
end
