% Setting the WDM channels wavelength in nm
function channelWavelengths = setChannelWavelengths(lambda, channelsSpacingHz, Nch)
cLight = 299792458; % [m/s]
fc = cLight/(lambda*1e-9);  % central channel frequency in Hz
channelsSpacing = (lambda)-(cLight/(fc+channelsSpacingHz))*10^9; % Spacing in [nm]
channelWavelengths = zeros(1,Nch);
if (mod(Nch,2))   % odd number of channels
    cont = 1;
    for chan = floor(Nch/2):-1:-floor(Nch/2)
        channelWavelengths(cont)=(cLight*lambda*1e-9)/...
            (((chan*channelsSpacingHz)*lambda*1e-9)+(cLight));
        cont = cont + 1;
    end
    channelWavelengths = channelWavelengths*1e9; % set the wavelengths to nm
else     % even number of channels
    cont = 1;
    for chan = 1:Nch/2
        channelWavelengths(cont)=(cLight*lambda)/...
            ((chan*channelsSpacingHz/2)+((chan-1)*channelsSpacingHz)*lambda+cLight);
%         link.channelWavelength(chan)=link.lambda+link.channelsSpacing*(chan-(link.numberChannels+1)/2);
        cont = cont + 1;
    end
end
