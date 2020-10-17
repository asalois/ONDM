%% Signal Generator

function [niosySig] = sigGen(M, nBits, chnl, EbNo, nsb, rb, fs) 

% Generate a PSK signal
msg = randi([0 M-1],nBits,1);
symbols = pskmod(msg, M);

% Pass the signal through the channel
%filtSig = filter(chnl,1,symbols);

% Make rectangular pulses
%pulseSig = rectpulse(filtSig, nsb);
pulseSig = rectpulse(symbols, nsb);

% Add AWGN to the signal
%SNR = EbNo + 10*log10(rb/fs);
%niosySig = awgn(pulseSig,SNR,'measured');
niosySig = pulseSig;

end

