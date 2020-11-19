function mat = makeInputMat(input,numSamples,numTrain)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
l = 2*numSamples + 1;
mat = zeros(l,numTrain);
for i = 1:l
    mat(i,:) = circshift(input(1:numTrain),i);
end
mat = [real(mat); imag(mat)];
end

