%% Adaptive Linear Equilizer

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois based on https://www.mathworks.com/help/comm/ug/adaptive-equalizers.html#a1049736245

% system setup
numTrainSymbols = 200;
trainingSymbols = filtSig(1:numTrainSymbols);

% eq setup
lineq = comm.LinearEqualizer('Algorithm','LMS', ...
    'NumTaps',20,'ReferenceTap',10,'StepSize',0.01);

[rxLMS,err] = lineq(filtSig,trainingSymbols);
release(lineq)
lineq.AdaptAfterTraining = false;
