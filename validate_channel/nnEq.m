%% Neural Network for channel equaliztion

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois
function output = nnEq(input,target,numTrain)
inR = real(input);
inC = imag(input);
trainingSymbols = [inR(1:numTrain), inC(1:numTrain)];
target = [real(target(1:numTrain)), imag(target(1:numTrain))];
testData = [inR(numTrain+1:end), inC(numTrain+1:end)];

Eqnet = patternnet(3);
% Train the Network
[Eqnet,TT] = train(Eqnet,trainingSymbols',target');

% Test the Network
output = Eqnet(testData');
output = [output(1,:) + output(2,:)*1i]';
end
