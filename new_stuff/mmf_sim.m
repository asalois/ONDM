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
num_modes = 2;                  % number of modes (includes polarized)

% create constants with c1^2 + c2^2 = 1 property
phy = pi/8; 
C = [cos(phy); sin(phy)];
% C = [cos(phy); sin(phy); cos(phy); sin(phy); cos(phy); sin(phy)];

% repeat Y on all rows and then multply by C
s = Y(ones(1,num_modes),:);
s = C.*s;

f = Fs*(0:(n-1))/n; % frequency vector
delay = 1:1:num_modes; % delay vector
r = mmf_MD(s,delay', f);
% r = runit(s, f);
x = ifft(r,[],2); % take ifft by rows

figure();
plot(t,pulse)
title('Gaussian Before')
xlabel('Time (s)')
ylabel('s(t)')

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


function [r] = runit(Y,f)
    mm = rand(2,1);
    r = Y;
    for i = 1:length(f)
        M  = [exp(-j*2*pi*f(i)) 0; 0 exp(-j*4*pi*f(i))];
        M = M*mm;
        r(:,i)= Y(:,i).*M;
    end
  
end