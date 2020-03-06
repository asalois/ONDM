function signalPower = getSignalPower_v1(x,y, Lh2)
%#codegen
% getSignalPower_v1 ignore the transition samples at the beginning and end
% of data sequence generated by pulse shaping f
% transmitter pulse shaping filter length

x1 = x(Lh2+1 : end-Lh2);  % remove the transmition samples generated by filter
y1 = y(Lh2+1 : end-Lh2);
signalPower = 10*log10((sum(abs(x1).^2)+sum(abs(y1).^2))./length(x1));