function niosySig = channel(inMsg,chnl,snr,delay)
% channel sends the msg through the channel to get ISI
%   more explantion here
filtSig = filter(chnl,1,inMsg); % produce ISI
filtSig = filtSig(delay:end); % cut first samples
niosySig = awgn(filtSig,snr,'measured'); % add niose
end

