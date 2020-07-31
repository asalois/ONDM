% Gaussian pulse distortion due to polarization mode dispersion

% Montana State University 
% Electrical & Computer Engineering Department
% Created by Alexander Salois
% Modeified by Ioannis Roudas (7/27/20)

%% Preliminary commands 

close all;
clear all;
clc; 

%% Simulation parameters

% Signal parameters
Ts = 1; % sampling period
Fs = 1/Ts; % sampling frequency 
num_samples_To = 4; % number of samples per To time interval
To = num_samples_To * Ts; % Gaussian pulse std deviation
num_To_intervals = 64; % number of To time intervals to be simulated
Tsim = num_To_intervals * To; % Total simulation time
nfft = num_samples_To * num_To_intervals; % Number of simulated samples
df = 1 / Tsim; % Frequency spacing in the frequency domain

% Fiber parameters
num_modes = 2; % number of modes that includes polarizations (smf w/ x y)
num_fibers = 1; % number of fibers to simulate
num_fiber_sections = 100; %number of fiber sections
tau = To/10; % Differential group delay (DGD) between x,y SOPs per segment

% Launch conditions

phi = pi/8; % Phase difference between x,y SOPs 
launch_jones_vector = [cos(phi); sin(phi)]; % Launch Jones vector


%% Gaussian pulse generation

t = (-Tsim/2 + Ts/2):Ts:(Tsim/2 - Ts/2); % time vector
g = exp(-t.^2/(2*To^2)); % Gaussian vector

%% Plot a Gaussian pulse

% figure()
% plot(t/To,g), 
% legend('Transmitted pulse')
% xlabel('Time (To)'), ylabel('s (t)')
% title('Transmitted Gaussian pulse')

%% Gaussian pulse spectrum

Y = fft(g); %  fft
G = fftshift(Y); % zero-centered spectrum
f = ((-nfft/2+1/2):(nfft/2-1/2))*df; % zero-centered frequency range

%% Plot a Gaussian pulse spectrum

% figure()
% plot(f/Fs,abs(G)), 
% legend('Transmitted pulse spectrum')
% xlabel('Frequency (fs)'), ylabel('G (f)')
% title('Transmitted Gaussian pulse')


%% Transfer matrix of the SMF

% You can make the transfer matrix generation into an *.m file

%rng(0,'twister'); % Initialize the random number generator
theta = 2*pi*rand(num_fiber_sections+1,1); %Generate random phases

% We will create nfft 2x2 random matrices

output_matrix = zeros(2,2,nfft); % Fiber transfer matrix initialization

for k=1:nfft % For all frequencies
    
    d = delay_matrix(f(k), tau);
    output_matrix(:,:,k) = rotation_matrix(theta(1));
    
    for i=1:num_fiber_sections
        output_matrix(:,:,k) = rotation_matrix(theta(i+1))*d*output_matrix(:,:,k);
    end
    
end

%% Signal propagation through the SMF

% You can multiply the transfer matrix at each frequency with the input
% Jones vector. This will give us an output Jones vector per frequency.
% Each Jones vector is scaled by the pulse spectrum G(f(k))
clc
out_pulse = zeros(2,256);
for k = 1:nfft
    m = launch_jones_vector .* G(k);
    m = output_matrix(:,:,k) * m;
    out_pulse(:,k) = m;
end
pulse = out_pulse(1,:) + out_pulse(2,:);

% figure()
% hold on
% plot(f/Fs,abs(out_pulse(1,:)))
% plot(f/Fs,abs(out_pulse(2,:)))
% plot(f/Fs,abs(pulse))
% xlabel('Frequency (fs)'), ylabel('G (f)')
% title('Transmitted Gaussian pulse')
% hold off

p0 = ifft(pulse);
p1 = ifft(out_pulse(1,:));
p2 = ifft(out_pulse(2,:));
p3 = p1 + p2;
figure()
hold on
plot(abs(p0))
plot(abs(p1))
plot(abs(p2))
plot(abs(p3))
hold off

