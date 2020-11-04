function shift = shiftCheck(in1,in2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
gpu1 = gpuArray(in1(1:length(in2)));
gpu2 = gpuArray(in2);
x = gpuArray(zeros(length(in1),1));
parfor i = 1:round(length(in1)/2)
    test = circshift(gpu1,i);
    n = dot(test,gpu2);
    x(i) = n;
end
[m,shift] = max(x)
end

