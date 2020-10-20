function rxDFE = dfEq(filtSig,taps,numSymbols,PSKConstellation)
% Adaptive Linear Equilizer using Least Mean Squares
% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% define number of symbols to train EQ
numTrainSymbols = numSymbols;
trainingSymbols = filtSig(1:numTrainSymbols);

dfe = comm.DecisionFeedbackEqualizer('Algorithm','LMS','NumForwardTaps',taps, ...
    'NumFeedbackTaps', taps-1,'StepSize',0.03,'ReferenceTap',floor(taps/2),...
    'Constellation',PSKConstellation);
   
% USE DFE 
[rxDFE] =  dfe(filtSig,trainingSymbols);
end

