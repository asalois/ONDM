clc;
close all;
Fs = 2^12;          % Sampling frequency
t = -1:1/Fs:1;      % Time vector 
L = length(t);      % Signal length
X = 1/(4*sqrt(2*pi*0.01))*(exp(-t.^2/(2*0.01))); % Gausian Pulse
n = 2^nextpow2(L);  % for better fft perf
Y = fft(X,n);   % the fft of the pulse
num_modes = 100;
y = zeros(num_modes,n);
fiber = rand(num_modes,n);
parfor i = 1:num_modes
    Z = Y.*fiber(i,:);
    y(i,:) = ifft(Z);
end

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


%%

Wo = 0.9; Wt = 0.8;
[AllpassNum, AllpassDen] = allpassshift(Wo, Wt);

[h, f] = freqz(AllpassNum, AllpassDen, 'whole');

plot(f/pi, abs(angle(h))/pi, Wt, Wo, 'ro');
title('Mapping Function Wo(Wt)');
xlabel('New Frequency, Wt'); ylabel('Old Frequency, Wo');