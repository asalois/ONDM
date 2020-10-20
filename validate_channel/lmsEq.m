%% Adaptive Linear Equilizer

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois

function rxLMS = lmsEq(filtSig,i,numSymbols,PSKConstellation)

% define number of symbols to train EQ
numTrainSymbols = numSymbols;
trainingSymbols = filtSig(1:numTrainSymbols);

% eq setup
if i > 1
	%lineq = comm.LinearEqualizer('Algorithm','LMS', 'NumTaps',i,'ReferenceTap',1,'StepSize',0.03,'InputSamplesPerSymbol',1);
    dfe = comm.DecisionFeedbackEqualizer('Algorithm','LMS','NumForwardTaps',i, ...
        'NumFeedbackTaps', i-1,'StepSize',0.03,'ReferenceTap',1,'Constellation',PSKConstellation);
 
end

% Use LinearEq
% [rxLMS,err] = lineq(filtSig,trainingSymbols);
% release(lineq)
% lineq.AdaptAfterTraining = false;

% USE DFE 
[rxLMS,err] =  dfe(filtSig,trainingSymbols);



