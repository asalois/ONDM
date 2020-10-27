%% Neural Network for channel equaliztion

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois
function output = nnEq(input,target,numTrain)
size = 14;
trainingSymbols = makeInputMat(input,size,numTrain);
target = [real(target(size:numTrain+size)), imag(target(size:numTrain+size))];
testData = makeInputMat(input,size,(length(input) - numTrain));

Eqnet = feedforwardnet(70,'traingd');
% Train the Network
[Eqnet,TT] = train(Eqnet,trainingSymbols,target','useGPU', 'yes');
%[Eqnet,TT] = train(Eqnet,trainingSymbols,target','useParallel','yes');

% Test the Network
output = Eqnet(testData);
output = [output(1,:) + output(2,:)*1i]';
end
