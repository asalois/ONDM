function [y] = mmf_MD(runs,Y,diag,modes,Fs,C)
% Multimode fiber simultion of Modal Dispersion using matrix concatantion
    if modes == length(diag)
        len = length(Y);
        f = Fs*(0:(len/2))/len;
        w = 2*pi.*f;
        run = floor(len/2);
        zz = Y(ones(1,modes),:);
        zz = C.*zz;
        y = zeros(runs,modes,len);
        parfor j = 1:runs
            u = rand(modes);
            for i = 1:run
                l = lamda(diag, w(i));
                m = l*u;
                y(j,:,i) = m*zz(:,i);
            end
        end
    else
        y = 0;
    end    
end