function d = delay_matrix(frequency, dgd)
    omega = 2 * pi * frequency;
    phase_shift = omega * dgd;
    v = exp([-j*phase_shift/2 j*phase_shift/2]);
    d = diag(v)
end