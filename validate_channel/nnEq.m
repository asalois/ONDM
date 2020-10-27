%% Neural Network for channel equaliztion

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois
function output = nnEq(input,target,numTrain)
trainingSymbols = makeInputMat(input,4,numTrain);
target = [real(target(1:numTrain)), imag(target(1:numTrain))];
testData = makeInputMat(input,4,(length(input) - numTrain));

Eqnet = patternnet(15);
% Train the Network
[Eqnet,TT] = train(Eqnet,trainingSymbols,target');

% Test the Network
output = Eqnet(testData);
output = [output(1,:) + output(2,:)*1i]';
end
