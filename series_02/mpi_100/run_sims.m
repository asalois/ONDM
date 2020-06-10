function run_sims(indx)
span  = [10, 20, 25, 30, 40, 50, 60, 75, 80, 120, 150]; % span length [km]
step  = [1, 2, 2.5, 3, 4, 5, 6, 7.5, 8, 10, 10]; % step length [km]
laser_power = [[-9:1:2]', [-9:1:2]', [-9:1:2]', [-8:1:3]', [-8:1:3]', [-7:1:4]', [-7:1:4]', [-6:1:5]', [-6:1:5]', [-3:1:8]', [-1:1:10]']; % Laser power [dBm]
%addpath('/mnt/lustrefs/scratch/v16b915/series_02/sim_files')
addpath('/home/alex/Documents/ONDM/series_02/sim_files')
comp = 100; % percentage of MPI compensation.  0 - full MPI, 100 - MPI fully compensated
alpha1 = 0.16; % QSM fiber attenuation [dB/km]
alpha2 = 0.158; % EX3000 fiber attenuation [dB/km]
aeff1 = 250; % QSM fiber effective area  [um^2]
aeff2 = 112; % EX3000 fiber effective area [um^2]
for i = 1:11
    if i == 1
        m = makeTable(laser_power(:,i)', span(i), step(i), comp, alpha1, alpha2, aeff1, aeff2);
    else
        m =[m makeTable(laser_power(:,i)', span(i), step(i), comp, alpha1, alpha2, aeff1, aeff2)];
    end
end
%qsmf_simulation_fft2(indx, m(1, indx), m(2, indx), m(3, indx), m(4, indx), m(5, indx), m(6, indx), m(7, indx), m(8, indx))
end
