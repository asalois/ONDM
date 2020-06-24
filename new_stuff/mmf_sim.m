clc;
close all;
clear all;
Fs = 2^13 -1;% Sampling frequency
str_end= 2;
t = -str_end:1/Fs:str_end;      % Time vector 
L = length(t);      % Signal length
Ak = 1;
To = 1/1000;
wo = 2*pi*Fs;
X = Ak*exp(-t.^2/(2*To^2)); % Gausian Pulse
n = 2^nextpow2(L);  % for better fft perf
Y = fft(X,n);   % the fft of the pulse
Z = [Y;Y];
num_modes = 2;
num_runs = 100;
inl = [1 1];
y = zeros(num_runs, num_modes,n);

tic
parfor j = 1:num_runs
    for i = 1:n
        w = 2*pi/i;
        l = lamda(inl, w);
        u = rand(num_modes);
        m = l*u;
        y(j,:,i) = m*Z(:,i);
    end
end
toc

% % plot
% figure()
% plot(t,X(1:length(t)) )
% title('Gaussian Pulse in Time Domain')
% xlabel('Time (t)')
% ylabel('X(t)')
%y= y';
x = ifft(y,[],2);
%x = x';

figure()
hold on
for i = 1:num_runs
    plot(t,abs(x(i,(1:length(t)))) )
end
title('Gaussian Pulse in Time Domain')
xlabel('Time (t)')
ylabel('X(t)')
hold off