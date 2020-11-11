%% Neural Network for channel equaliztion

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois
function output = nnEq(input,target,numTrain)
size = 14;
hLayers = round(size*4*1.25);
shift = size+1;
trainingSymbols = makeInputMat(input,size,numTrain);
test = input(numTrain+1:end);
target = [real(target(shift:numTrain+shift-1)), imag(target(shift:numTrain+shift-1))];
testData = makeInputMat(test,size,length(test)-(2*size+1));
load Eqnet
% Eqnet = feedforwardnet(hLayers,'traingd');
% Eqnet = patternnet(hLayers,'traingd');
% Eqnet.layers{2}.transferFcn = 'purelin';
% Eqnet.layers{1}.transferFcn = 'purelin';
% Eqnet = patternnet(hLayers);
% Train the Network
[Eqnet,TT] = train(Eqnet,trainingSymbols,target','useGPU', 'yes');
%[Eqnet,TT] = train(Eqnet,trainingSymbols,target','useParallel','yes');

% Test the Network
output = Eqnet(testData);
output = [output(1,:) + output(2,:)*1i]';
save Eqnet
end
