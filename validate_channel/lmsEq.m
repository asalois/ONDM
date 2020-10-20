%% Adaptive Linear Equilizer

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois based on https://www.mathworks.com/help/comm/ug/adaptive-equalizers.html#a1049736245
function rxLMS = lmsEq(filtSig,i,M)

% system setup
numTrainSymbols = 2000;
% msg = randi([0 M-1],numTrainSymbols,1);
% trainingSymbols = pskmod(msg,M);
trainingSymbols = filtSig(1:numTrainSymbols);

% eq setup
if i > 1
	%lineq = comm.LinearEqualizer('Algorithm','LMS', 'NumTaps',i,'ReferenceTap',1,'StepSize',0.03,'InputSamplesPerSymbol',1);
    dfe = comm.DecisionFeedbackEqualizer('Algorithm','LMS','NumForwardTaps',i, 'NumFeedbackTaps', i-1,'StepSize',0.03,'ReferenceTap',1);
else
	%lineq = comm.LinearEqualizer('Algorithm','LMS', 'NumTaps',i,'ReferenceTap',1,'StepSize',0.01);
end

% [rxLMS,err] = lineq(filtSig,trainingSymbols);
% release(lineq)
% lineq.AdaptAfterTraining = false;
[rxLMS,err] =  dfe(filtSig,trainingSymbols);
% release(dfe)


