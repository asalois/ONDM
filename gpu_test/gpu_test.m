%% scrip to test gpu performance
array_size = 1000;
M = rand(array_size);
G = gpuArray(M);

% cpu fft test
tic;
cpu = fft(M);
time_cpu = toc;

% gpu fft test
tic;
gpu = fft(G);
time_gpu = toc;

speed_up = time_cpu / time_gpu;

