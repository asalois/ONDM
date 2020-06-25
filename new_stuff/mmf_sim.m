%% sim
clc;
close all;
clear all;

tic
start_stuff();
num_modes = 4; % number of modes in fiber
num_runs = 1000; % number of runs to compute
TTo = 0.001:0.001:0.01
inl = [1 1 1 1];
for i = 1:10 
To = TTo(i);
pulse = Ak*exp(-t.^2/(2*To^2)); % Gausian Pulse
n = 2^nextpow2(length(pulse));  % for better fft perf
Y = fft(pulse,n);
y = run_it(num_runs,Y,inl,num_modes);
x = ifft(y,[],2);
toc
plot_it(t,x,To,i)

end

function plot_it(t, x, To, k)
    figure()
    hold on
    for i = 1:size(x,1)
        plot(t,abs(x(i,(1:length(t)))) )
    end
    formatSpec = 'Gaussian Pulse w/ %5.4f in Time Domain\n';
    ttl = sprintf(formatSpec,To);
    title(ttl);
    xlabel('Time (t)')
    ylabel('X(t)')
    formatSpec = 'to_%d';
    name =  sprintf(formatSpec,k)
    hold off
    saveas(gcf,name,'png');
end

function start_stuff()
    Fs = 2^13 -1;% Samplingfrequency
    str_end= 5;
    t = -str_end:1/Fs:str_end;      % Time vector 
    L = length(t);      % Signal length
    Ak = 1;
    wo = 2*pi*Fs;
    assignin('base','Fs', Fs)
    assignin('base','t', t)
    assignin('base','Ak', Ak)
    assignin('base','wo', wo)
end

function [y] = run_it(runs,Y,diag,modes)
    if modes == length(diag)
        len = length(Y);
        zz = Y(ones(1,modes),:);
        y = zeros(runs,modes,len);
        parfor j = 1:runs
            for i = 1:len
                w = 2*pi/i;
                l = lamda(diag, w);
                u = rand(modes);
                m = l*u;
                y(j,:,i) = m*zz(:,i);
            end
        end
    else
        y = 0;
    end    
end