%% Make a Unitary Matrix of NxN using Ozol's Method

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois

%% Preliminary commands 

close all;
clear all;
clc; 

%% Generate Random Numbers from Normal Distribution

N = 2; % matrix size
rr = normrnd(0,1,N,N); % make a NxN matrix of random numbers from normal distribution
ri = normrnd(0,1,N,N);
M = rr + ri*1i; % make complex


%% Tests

U = orth(M); % orthangonalize
U1 = U'*U; % transposed times orginal
U2 = U*U'; % orginal times transposed
round_to = 10; % rounding to this number of digits
U1 = round(U1,round_to); % round off to get rid of - zeros
U2 = round(U2,round_to);% round off to get rid of - zeros
id = eye(N); % identity matrix

if U1 == U2
    fprintf("First check: success\n U1 = U2\n\n");
    if U1 == id
        fprintf("Second check: success\n U1 = Identity Matrix\n\n");
    else
        fprintf("Second check: failed\n U1 =/= Identity Matrix\n\n");
    end
else
    fprintf("First check: failed\n U1 =/= U2\n\n");
end
