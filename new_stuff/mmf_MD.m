function [y] = mmf_MD(runs,Y,diag,modes)
% Multimode fiber simultion of Modal Dispersion using matrix concatantion
    if modes == length(diag)
        len = length(Y);
        zz = Y(ones(1,modes),:);
        y = zeros(runs,modes,len);
        parfor j = 1:runs
            for i = 1:len
                w = 2*pi/i;
                l = lamda(diag, w);
                u = rand(modes);
                m = l*u;
                y(j,:,i) = m*zz(:,i);
            end
        end
    else
        y = 0;
    end    
end