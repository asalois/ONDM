function [y] = mmf_MD(Y, delay, f)
    % Multimode fiber simultion of Modal Dispersion using matrix concatantion
    ees = exp(-j*2*pi*delay.*f);
    y = Y.*ees;
end