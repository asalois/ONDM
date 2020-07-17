% start over
close all;
clear all;
clc; 

% Sampling setup
Ts = 1; % sampling period
Fs = 1/Ts; % sampling frequency 
num_samples = 16; % number of samples to take
T = num_samples * Ts; 
Tsim = 8*T; % sample time
nsim = Tsim / Ts;

To = 1 ; % Guasian spread
t = -Tsim/2:Ts:Tsim/2;
g = exp(-t.^2/(2*To^2));

plot(t,g);
