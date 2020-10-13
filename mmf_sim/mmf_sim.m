% QAM-16 with polarization mode dispersion

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois
% Modified by Ioannis Roudas (7/29/20)

%% Preliminary commands 
close all;
clear all;
clc; 

%% Simulation parameters
% Signal parameters
M = 16; % Modulation order
k = log2(M); % Bits/symbol
n = 5000*k; % Transmitted bits
nSamp = 4; % Samples per symbol
EbNo = 20; % Eb/No (dB)

% Fiber parameters
num_modes = 2; % number of modes that includes polarizations (smf w/ x y)
num_fibers = 1; % number of fibers to simulate
num_fiber_sections = 100; %number of fiber sections
tau = 1/100000; % Differential group delay (DGD) between x,y SOPs per segment

% Launch conditions
phi = pi/4; % Phase difference between x,y SOPs 
launch_jones_vector = [cos(phi); sin(phi)]; % Launch Jones vector


%% Filter Paramters
span = 50; % Filter span in symbols
rolloff = 0.25; % Rolloff factor


%% Create the raised cosine transmit and receive filters using the previously defined parameters.
txfilter = comm.RaisedCosineTransmitFilter('RolloffFactor',rolloff, ...
    'FilterSpanInSymbols',span,'OutputSamplesPerSymbol',nSamp);

rxfilter = comm.RaisedCosineReceiveFilter('RolloffFactor',rolloff, ...
    'FilterSpanInSymbols',span,'InputSamplesPerSymbol',nSamp, ...
    'DecimationFactor',nSamp);

%% Plot the impulse response of hTxFilter.
%fvtool(txfilter,'impulse')

%% Make Tx signal
% Calculate the delay through the matched filters. 
% The group delay is half of the filter span through one filter and is, 
% therefore, equal to the filter span for both filters. 
% Multiply by the number of bits per symbol to get the delay in bits.
filtDelay = k*span; 
errorRate = comm.ErrorRate('ReceiveDelay',filtDelay); % set error rate
x = randi([0 1],n,1); % random bit stream 
modSig = qammod(x, M,'InputType','bit'); % modulate
txSig = txfilter(modSig); % filter modulted signal

%% Tx spectrum
nfft = 2^nextpow2(length(txSig));
Y = fft(txSig,nfft); %  fft
G = fftshift(Y); % zero-centered spectrum
f = ((-nfft/2+1/2):(nfft/2-1/2))*nSamp; % zero-centered frequency range

%% Transfer matrix of the SMF
% You can make the transfer matrix generation into an *.m file

% rng(0,'twister'); % Initialize the random number generator
theta = 2*pi*rand(num_fiber_sections+1,1); %Generate random phases
% theta = theta + 1i*2*pi*rand(num_fiber_sections+1,1); %Generate random phases
% theta = zeros(num_fiber_sections+1,1); % No rotations

% We will create nfft 2x2 random matrices

output_matrix = zeros(2,2,nfft); % Fiber transfer matrix initialization

parfor k=1:nfft % For all frequencies
    
    d = delay_matrix(f(k), tau);
    output_matrix(:,:,k) = rotation_matrix(theta(1));
    %U = make_unitary(2);
    %output_matrix(:,:,k) = U;
    for i=1:num_fiber_sections
        output_matrix(:,:,k) = rotation_matrix(theta(i+1))*d*output_matrix(:,:,k);
        %output_matrix(:,:,k) = U*d*output_matrix(:,:,k);
    end
end

%% Signal propagation through the SMF
% You can multiply the transfer matrix at each frequency with the input
% Jones vector. This will give us an output Jones vector per frequency.
% Each Jones vector is scaled by the pulse spectrum G(f(k))

out_pulse = zeros(2,nfft);
for k = 1:nfft
    out_pulse(:,k) = G(k)* output_matrix(:,:,k) * launch_jones_vector;
    %out_pulse(:,k) = G(k)* eye(2)* launch_jones_vector;
end

% Output electric fields x,y SOPs
ex = ifft(fftshift(out_pulse(1,:)));
ey = ifft(fftshift(out_pulse(2,:)));

rxSig = rxfilter(ex');
scatterplot(rxSig)

rxSig = rxfilter(ey');
scatterplot(rxSig)


