%% scrip to test gpu performance
clc
clear all
runs = 50;
power = 13;
times = zeros(5,power*runs);
for j = 1:5
for k = 1:power
    array_size = 2^k;
    fftw('dwisdom', []);
    switch j
	case 1   
    		fftw('planner','estimate');
    	case 2   
    		fftw('planner','measure');
	case 3   
    		fftw('planner','patient');
	case 4   
    		fftw('planner','exhaustive');
	case 5
		fftw('planner', 'hybrid');	
	otherwise
		disp('not it')
    end
    for i = ((k-1)*runs + 1):k*runs
        % cpu fft test
        tic;
        M = rand(array_size);
        cpu = fft(M);
        inv = ifft(cpu);
        time_cpu = toc;
        
        times(j,i) = time_cpu;
    end
end
sum(times(1,:))
end
x = 1:power*runs;
figure()
fig = plot(x, times(1,:), x, times(2,:), x, times(3,:), x, times(5,:));
title('Time (s)');
xlabel('run #');
ylabel('Time (Seconds)');
legend({'estimate', 'measure', 'patient', 'exhaustive',' hybrid'},'Location', 'northwest');
saveas(gcf, 'time.png');
