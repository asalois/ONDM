clc;
close all;
Fs = 2^15;          % Sampling frequency
t = -1:1/Fs:1;      % Time vector 
L = length(t);      % Signal length
Ak = 1;
To = 1/Fs;
wo = 2*pi*Fs;
X = exp(-t.^2/(2*To^2)); % Gausian Pulse
n = 2^nextpow2(L);  % for better fft perf
Y = fft(X,n);   % the fft of the pulse
num_modes = 1;
y = zeros(num_modes,n);
u = rand(num_modes,n);
for i = 1:length(Y) 
    w = 2*pi/i;
    l = lamda([pi/2], w);
    u = rand(num_modes);
    m = l*u;
    y(i) = Y(i)*m;
end
y = ifft(y);

% plot
figure()
hold on
for i = 1:num_modes
    plot(t,abs(y(i,(1:length(t)))))
    title('Gaussian Pulse in Time Domain')
    xlabel('Time (t)')
    ylabel('X(t)')
end
hold off