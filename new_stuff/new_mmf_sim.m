% start over
close all;
clear all;
clc; 

% Sampling setup
Ts = 1; % sampling period
Fs = 1/Ts; % sampling frequency 
num_samples = 2^5; % number of samples to take
T = num_samples * Ts; 
Tsim = 2*T; % sample time
dt = 1/Tsim; % change in t

% signal setup
To = 1 ; % Guasian spread
t = -Tsim/2:dt:Tsim/2 -dt; % time vector
g = exp(-t.^2/(2*To^2)); % guassian vector
Y = fft(g); % take fft
n = length(Y); % length of fft
f = Fs*(0:(n-1))/n; % frequncy vector
w = f.*2*pi; % omega vector 

% Model Setup
modes = 2; % number of modes that includes polarizations (smf w/ x y)
fibers = 1; % number of fibers to make
fiber_sections = 100; %number of fiber sections
delay = [2 4]; % delay in x and y 
phy = pi/8; % Launch power 
launch_power = [cos(phy); sin(phy)]; % launch power x^2 +y^2 = 1
s = Y(ones(1,modes),:); % copy y to both modes
s = launch_power.*s; % multply by launch power
out = s; % make a vector for output

% the fiber is frequncy dependant so run this per frequncy 
for k = 1:length(w)
    fiber = make_fiber(w(k),modes,fiber_sections,delay);
    out(:,k) = fiber*s(:,k); % write it to the output
end

x = ifft(out,[],2); % inverse fft by rows
out = x(1,:) + x(2,:); % add the rows
x = [x; out]; % concatante to see the addition



% plot a 2d vector of magnitudes
figure()
hold on
for i = 1:size(x,1)
    plot(t,abs(x(i,(1:length(t)))) )
end
title('Guassians after launch');
xlabel('Time (s)')
ylabel('r(t)')
hold off

