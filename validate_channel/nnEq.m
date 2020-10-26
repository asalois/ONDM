%% Neural Network for channel equaliztion

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois
function output = nnEq(input,target,numTrain)
inR = real(input);
inC = imag(input);
trainingSymbols = [inR(1:numTrain+1), inC(1:numTrain+1)];
target = [real(target), imag(target)];
testData = [inR(numTrain+1:end), inC(numTrain+1:end)];

Eqnet = patternnet(3);
% Train the Network
[Eqnet,TT] = train(Eqnet,trainingSymbols',target');

% Test the Network
output = Eqnet(testData');
output = [output(1,:) + output(2,:)*i];
end
