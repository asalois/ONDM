function shift = shiftCheck(in1,in2,iter)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
in1 = in1(1:length(in2));
x = zeros(iter,1);
parfor i = 1:iter
    test1 = circshift(in1,i);
    test2 = in2;
    right = [test1 == test2];
    n = nnz(right);
    x(i) = n;
end
[~,shift] = max(x);
end

