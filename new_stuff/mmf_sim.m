clc;
close all;
clear all;
Fs = 256*10^3;% Sampling frequency
t = -1:1/Fs:1;      % Time vector 
L = length(t);      % Signal length
Ak = 1;
To = 1/10;
wo = 2*pi*Fs;
X = Ak*exp(-t.^2/(2*To^2)); % Gausian Pulse
n = 2^nextpow2(L);  % for better fft perf
Y = fft(X,n);   % the fft of the pulse
Z = [Y;Y];
Z = Z';
num_modes = 2;
inl = [To To];
y = zeros(num_modes,n);

for i = 1:length(Y) 
    w = 2*pi/i;
    l = lamda(inl, w);
    u = rand(num_modes);
    m = l*u;
    y(:, i) = Z(i,:)*m;
    y(:, i) = ifft(y(:, i));
end



% plot
figure()
plot(t,X(1:length(t)) )
title('Gaussian Pulse in Time Domain')
xlabel('Time (t)')
ylabel('X(t)')


figure()
hold on
for i = 1:num_modes
    plot(t,abs(y(i,(1:length(t)))) )
end
title('Gaussian Pulse in Time Domain')
xlabel('Time (t)')
ylabel('X(t)')
hold off