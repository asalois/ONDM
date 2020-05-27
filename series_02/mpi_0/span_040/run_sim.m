%% fucntion to run simultions


function run_sim(indx)

    addpath('/mnt/lustrefs/scratch/v16b915/series_02/sim_files')
    laser_power = -9:1:2; % Laser power [dBm] 
    span = 40; % span length [km]
    step_size = span/10; % step size of segment length [km]
    seg_len = 0:step_size:span;  % first segement length,must < spanLength [km]
    comp = 0; % percentage of MPI compensation.  0 - full MPI, 100 - MPI fully compensated
    alpha1 = 0.16; % QSM fiber attenuation [dB/km]
    alpha2 = 0.158; % EX3000 fiber attenuation [dB/km]
    aeff1 = 250; % QSM fiber effective area  [um^2]
    aeff2 = 112; % EX3000 fiber effective area [um^2]
    m = combvec(laser_power, span, seg_len, comp, alpha1, alpha2, aeff1, aeff2); % a vector to combine and have all possible 
    qsmf_simulation_fft2(indx, m(1, indx), m(2, indx), m(3, indx), m(4, indx), m(5, indx), m(6, indx), m(7, indx), m(8, indx))
end
