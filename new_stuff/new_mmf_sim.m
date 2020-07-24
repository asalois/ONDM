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
nsim = Tsim / Ts;
df = 1/Tsim;

To = 1 ; % Guasian spread
t = -Tsim/2:df:Tsim/2 -df;
g = exp(-t.^2/(2*To^2));
Y = fft(g);
n = length(Y);
f = Fs*(0:(n-1))/n;
w = f.*2*pi;
w = w';

% Model Setup
modes = 2;
fibers = 1;
fiber_sections = 100;
delay = [2 4];
phy = pi/8; 
C = [cos(phy); sin(phy)];
s = Y(ones(1,modes),:);
s = C.*s; 
out = s; 


for k = 1:length(w)
    fiber = make_fiber(w(k),modes,fiber_sections,delay);
    out(:,k) = fiber*s(:,k);
end
x = ifft(out,[],2);
out = x(1,:) + x(2,:);
x = [x; out];



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



function [fiber] = make_fiber(w, modes, fiber_sections,delay)
    %fiber = zeros(modes,modes,fiber_sections);
    m = diag([exp(-j*w*delay(1)) exp(-j*w*delay(2))]);
    f = repmat(m,[1 1 fiber_sections]);
    fiber = f(:,:,1);
    for slice = 2:fiber_sections
        fiber = fiber*f(:,:,slice);
    end
end
