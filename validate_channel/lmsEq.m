%% Adaptive Linear Equilizer

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois based on https://www.mathworks.com/help/comm/ug/adaptive-equalizers.html#a1049736245
function rxLMS = lmsEq(filtSig,i)

% system setup
numTrainSymbols = 2000;
trainingSymbols = filtSig(1:numTrainSymbols);

% eq setup
if i > 2
	lineq = comm.LinearEqualizer('Algorithm','LMS', ...
    	  'NumTaps',i,'ReferenceTap',floor(i/2),'StepSize',0.01);
else
	lineq = comm.LinearEqualizer('Algorithm','LMS', ...
    	  'NumTaps',i,'ReferenceTap',1,'StepSize',0.01);
end

[rxLMS,err] = lineq(filtSig,trainingSymbols);
release(lineq)
lineq.AdaptAfterTraining = false;
