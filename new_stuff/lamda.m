function [out] = lamda(in1, w)
% Makes a matrix length(inl) x length(inl) with the diagonals being inl
n = length(in1);
I = eye(n);
ex = exp(-j*w.*in1);
out =  I.*ex;
end

