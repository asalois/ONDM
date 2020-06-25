%% small pulse
clc;
close all;
clear all;

tic
start_stuff();
To = 1/1000;
pulse = Ak*exp(-t.^2/(2*To^2)); % Gausian Pulse
Y = fft(pulse,n);   % the fft of the pulse
Z = [Y;Y];
num_modes = 2;
num_runs = 1000;
inl = [1 1];
y = zeros(num_runs, num_modes,n);
parfor j = 1:num_runs
    for i = 1:n
        w = 2*pi/i;
        l = lamda(inl, w);
        u = rand(num_modes);
        m = l*u;
        y(j,:,i) = m*Z(:,i);
    end
end
x = ifft(y,[],2);
toc
plot_it(t,pulse)
plot_it(t,x)



%% long pulse
clc;
close all;
clear all;

tic
start_stuff();
To = 1/4;
pulse = Ak*exp(-t.^2/(2*To^2)); % Gausian Pulse
Y = fft(pulse,n);   % the fft of the pulse
Z = [Y;Y];
num_modes = 2;
num_runs = 1000;
inl = [1 1];
y = zeros(num_runs, num_modes,n);
parfor j = 1:num_runs
    for i = 1:n
        w = 2*pi/i;
        l = lamda(inl, w);
        u = rand(num_modes);
        m = l*u;
        y(j,:,i) = m*Z(:,i);
    end
end
x = ifft(y,[],2);
toc
plot_it(t,pulse)
plot_it(t,x)




function plot_it(t, x)
    figure()
    hold on
    for i = 1:size(x,1)
        plot(t,abs(x(i,(1:length(t)))) )
    end
    title('Gaussian Pulse in Time Domain')
    xlabel('Time (t)')
    ylabel('X(t)')
    hold off
end

function start_stuff()
    Fs = 2^10 -1;% Samplingfrequency
    str_end= 5;
    t = -str_end:1/Fs:str_end;      % Time vector 
    L = length(t);      % Signal length
    n = 2^nextpow2(L);  % for better fft perf
    Ak = 1;
    wo = 2*pi*Fs;
    assignin('base','Fs', Fs)
    assignin('base','t', t)
    assignin('base','n', n)
    assignin('base','Ak', Ak)
    assignin('base','wo', wo)
end