%% scrip to test gpu performance
clc
clear all
runs = 50;
power = 13;
times = zeros(2,power*runs);

for k = 1:power
    array_size = 2^k;
    fftw('dwisdom', []);
    fftw('planner','patient');
    for i = ((k-1)*runs + 1):k*runs
        % cpu fft test
        tic;
        M = rand(array_size);
        cpu = fft(M);
        inv = ifft(cpu);
        time_cpu = toc;
        
        times(1,i) = time_cpu;
        times(2,i) = array_size;
    end
end
sum(times(1,:))
figure()
fig = plot(times(1,:));
title('Time (s)');
xlabel('run #');
ylabel('Time (Seconds)');
%legend({'cpu', 'gpu'}, 'Location', 'northwest');
saveas(gcf, 'time.png');
