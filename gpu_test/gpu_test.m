%% scrip to test gpu performance
clc
clear all
runs = 30;
power = 13;
times = zeros(4,power*runs);
    
for k = 1:power
    array_size = 2^k;
    for i = ((k-1)*runs + 1):k*runs
        % cpu fft test
        tic;
        M = rand(array_size);
        cpu = fft(M);
        inv = ifft(cpu);
        time_cpu = toc;
        
        % gpu fft test
        tic;
        G = gpuArray(M);
        gpu = fft(G);
        invg = ifft(G);
        time_gpu = toc;
        
        speed_up = time_cpu / time_gpu;
        
        times(1,i) = time_cpu;
        times(2,i) = time_gpu;
        times(3,i) = speed_up;
        times(4,i) = array_size;
    end
end
%%
figure()
fig = plot(times(4,:),times(1,:),times(4,:),times(2,:));
title('Array Size vs Time (s)');
xlabel('Array Size (RxR)');
ylabel('Time (Seconds)');
legend({'cpu', 'gpu'}, 'Location', 'northwest');
saveas(gcf, 'size_vs_time.png');