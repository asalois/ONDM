function signalPower = getSignalPower(x,y)
%#codegen

signalPower = 10*log10((sum(abs(x).^2)+sum(abs(y).^2))./length(x));