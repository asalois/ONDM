function [out] = lamda(in1, w)
% UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n = length(in1);
I = eye(n);
ex = exp(-j*w.*in1);
out =  I.*ex;
end

