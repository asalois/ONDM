function rxLMS = lmsEq(filtSig,taps,numSymbols)
% Adaptive Linear Equilizer using Least Mean Squares
% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% define number of symbols to train EQ
numTrainSymbols = numSymbols;
trainingSymbols = filtSig(1:numTrainSymbols);

% eq setup
lineq = comm.LinearEqualizer('Algorithm','LMS', 'NumTaps',taps,'ReferenceTap',floor(taps/2),...
    'StepSize',0.03,'InputSamplesPerSymbol',1,'Constellation',pskmod(0:1,2));

% Use LMS Equalizer
[rxLMS] = lineq(filtSig,trainingSymbols);

end




