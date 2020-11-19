function shift = shiftCheck(in1,in2,runTo)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% to use gpu
% gpu1 = gpuArray(in1(1:length(in2)));
% gpu2 = gpuArray(in2);
% x = gpuArray(zeros(length(in1),1));

% to not use gpu
gpu1 = in1(1:length(in2));
gpu2 = in2;
x = zeros(length(in1),1);

parfor i = 1:runTo
    test = circshift(gpu1,i);
    n = dot(test,gpu2);
    x(i) = n;
end
[m,shift] = max(x);
end

