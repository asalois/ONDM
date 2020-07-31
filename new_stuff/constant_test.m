%% constant test
clc;
close all;
clear all;

tic
C = [0.97; 0.2];
Fs = 2^12 -1;% Samplingfrequency
str_end= 2;
t = -str_end:1/Fs:str_end;      % Time vector
L = length(t);      % Signal length
Ak = 1;
To = 0.001;
pulse = Ak*exp(-t.^2/(2*To^2)); % Gausian Pulse
n = 2^nextpow2(length(pulse));  % for better fft perf
Y = fft(pulse,n);
f = Fs*(0:(n/2))/n;
P = abs(Y/n);

plot(f,P(1:n/2+1)) 
title('Gaussian Pulse in Frequency Domain')
xlabel('Frequency (f)')
ylabel('|P(f)|')