%% Signal Generator

function niosySig = sigGen(M, nBits, chnl, EbNo) 

% Generate a PSK signal
msg = randi([0 M-1],nBits,1);
txSig = pskmod(msg, M);

% Pass the signal through the channel
filtSig = filter(chnl,1,txSig);

% Add AWGN to the signal
SNR = EbNo + 10*log10(Rb/Fs);
noisySig = awgn(filtSig,SNR,'measured');
