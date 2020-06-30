%% sim
clc;
close all;
clear all;

tic
Fs = 2^10 -1;% Samplingfrequency
str_end= 2;
t = -str_end:1/Fs:str_end;      % Time vector
L = length(t);      % Signal length
Ak = 1;
C = [0.97; 0.2];
num_modes =2; % number of modes in fiber
num_runs = 2; % number of runs to compute
TTo = 0.001:0.001:0.001; % Guasian spread vector
inl = ones(1,floor(num_modes/2)); % create half
inl = [inl inl.*-1]; % half with neg
inl = inl.*1/num_modes; % normailze


% plot the Guassians without changing them
% for i = 1:length(TTo) 
%     To = TTo(i);
%     pulse = Ak*exp(-t.^2/(2*To^2)); % Gausian Pulse
%     plot_it(t,pulse,To,i)
% end

% MMF sim
 for i = 1:length(TTo) 
    To = TTo(i);
    pulse = Ak*exp(-t.^2/(2*To^2)); % Gaussian Pulse
    plot_it(t,pulse,To,i)
    n = 2^nextpow2(length(pulse));  % for better fft perf
    Y = fft(pulse,n);
    plot_phase(t,Y,To,i)
%     plot_it(t,x,To,i)
%     x = ifft(y,[],2);
%     plot_it(t,x,To,i)
    toc
end

