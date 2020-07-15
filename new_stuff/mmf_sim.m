%% sim
clc;
close all;
clear all;

Fs = 2^10 -1;                   % Sampling frequency
str_end= 10;                     % How long to make time vector
t = -str_end:1/Fs:str_end;      % Time vector
To = 1/4;                       % Guasian spread
pulse = exp(-t.^2/(2*To^2));    % Gaussian Pulse
n = 2^nextpow2(length(pulse));  % for better fft perf
Y = fft(pulse,n);               % frequency domain

% create constants with c1^2 + c2^2 = 1 property
phy = pi/8;                    
C = [cos(phy); sin(phy); cos(phy); sin(phy); cos(phy); sin(phy)];

zz = Y(ones(1,6),:);
zz = C.*zz;

M = [1 0; 0 1];

% MMF sim

f = Fs*(0:(n-1))/n;
delay = 1:1:6;
r = runit(zz,delay', f);
x = ifft(r,[],2);

figure();
plot(t,pulse)
title('Gaussian Before')
xlabel('Time (s)')
ylabel('angle(P1(f))')

% plot a 2d vector of magnitudes
figure()
hold on
for i = 1:size(x,1)
    plot(t,abs(x(i,(1:length(t)))) )
end
title('Guassians after launch');
xlabel('Time (t)')
ylabel('X(t)')
hold off


function [r] = runit(Y, delay,f)
    ees = exp(-j*2*pi*delay.*f);
    r = Y.*ees;
end