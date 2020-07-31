function U = make_unitary(N)
% Make a Unitary Matrix of NxN using Ozol's Method
    rr = normrnd(0,1,N,N); % make a NxN matrix of random numbers from normal distribution
    ri = normrnd(0,1,N,N);
    U = rr + ri*1i; % make complex
    U = orth(U); % orthangonalize
end

