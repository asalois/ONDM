clc;
close all;
Fs = 2^15;          % Sampling frequency
t = -1:1/Fs:1;      % Time vector 
L = length(t);      % Signal length
X = 1/(4*sqrt(2*pi*0.01))*(exp(-t.^2/(2*0.01))); % Gausian Pulse
n = 2^nextpow2(L);  % for better fft perf
Y = fft(X,n);   % the fft of the pulse
num_modes = 100;
fiber = rand(num_modes,n);
Z = fiber.*Y;
y = ifft(Z);


%% cpu part
y = zeros(num_modes,n);
tic
parfor i = 1:num
    b = rand(1,n);      % random vector
    Z = Y.*b;           % multiply by the random
    y(i, :) = ifft(Z,n);
end
toc


%% gpu part
y_g = gpuArray(zeros(num,n));
X_g = gpuArray(X);
Y = fft(X_g,n);       % the fft of the pulse

tic
parfor i = 1:num
    b = gpuArray(rand(1,n));      % random vector
    Z = Y.*b;           % multiply by the random
    y_g(i, :) = ifft(Z,n);
end
y = gather(y_g);
toc

%% plot
% f = Fs*(0:(n/2))/n;
% P = abs(Y/n);
% figure()
% plot(t,X)
% title('Gaussian Pulse in Time Domain')
% xlabel('Time (t)')
% ylabel('X(t)')
% 
% figure()
% plot(f,P(1:n/2+1)) 
% title('Gaussian Pulse in Frequency Domain')
% xlabel('Frequency (f)')
% ylabel('|P(f)|')
figure()
hold on
for i = 1:num_modes
    plot(t,abs(y(i,(1:length(t)))))
    title('Gaussian Pulse in Time Domain')
    xlabel('Time (t)')
    ylabel('X(t)')
end
hold off