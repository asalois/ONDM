function [out] = lamda(in1, w)
% UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n = length(in1);
I = eye(n);
I = I.*0.9;
ex = exp(-j*w.*in1);
out =  I.*ex;
end

