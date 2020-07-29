function d = delay_matrix(frequency, dgd)
% This creates a delay matrix that is based on the inputs frequcny and dgd
    omega = 2 * pi * frequency;
    phase_shift = omega * dgd;
    v = exp([-j*phase_shift/2 j*phase_shift/2]);
    d = diag(v);
end