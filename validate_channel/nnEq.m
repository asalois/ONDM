%% Neural Network for channel equaliztion

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
function output = nnEq(input,target,numTrain)
size = 25;
hLayers = round(size*4*1.25);
shift = size+1;
trainingSymbols = makeInputMat(input,size,numTrain);
target = [real(target(shift:numTrain+shift-1)), imag(target(shift:numTrain+shift-1))];
testData = makeInputMat(input,size,(length(input) - numTrain));

% Eqnet = patternnet(hLayers,'traingd');
% Eqnet.layers{2}.transferFcn = 'purelin';
Eqnet = feedforwardnet(hLayers,'traingd');
% Eqnet = patternnet(hLayers);
% Train the Network
[Eqnet,TT] = train(Eqnet,trainingSymbols,target','useGPU', 'yes');
%[Eqnet,TT] = train(Eqnet,trainingSymbols,target','useParallel','yes');

% Test the Network
output = Eqnet(testData);
output = [output(1,:) + output(2,:)*1i]';
end
