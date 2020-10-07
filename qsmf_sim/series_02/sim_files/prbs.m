function b = prbs(n, taps, N, r)
%
% Generating psuedo-random binary-sequence
%
%  b = prbs(n, taps, N)
%
%   n: Number of bits in the shift-register
%   taps: feedback taps
%   N: Number of bits to output, default = 2^n-1
%   r: initial n bit 1, 0 sequence as a seed 
%
% Some examples for the taps
%  n = 7   [7, 6][7, 3][7, 1]
%  n = 9   [9,5]
%  n = 10  [10, 7][10, 3]
%  n = 11  [11, 9]
%  n = 12  [12, 9, 8, 5]
%  n = 13  [13, 12, 10, 9]
%  n = 14  [14, 13, 10, 9]
%  n = 15  [15,14][15,4]
%  n = 23  [23, 18][23, 5]
%  n = 31  [31,28]

if (nargin < 1)
     taps = [7, 6];
     n = 7;
end

if (nargin < 3)
     N = 2^n-1;
end

if (nargin < 4)
% Find a random seed
while (1)
    r = randn(1, n) > 0;
    if sum(r) > 0, break; end
end
end

b = zeros(1,N);
t = zeros(1, n);
t(taps) = ones(size(taps));

% Operate the shift-register to generate random bits
for i = 1:N
     b(i) = r(n);
     t1 = mod(sum(r.*t), 2);
     r(2:n) = r(1:n-1);
     r(1) = t1;
end


