function dataOut = bitsGenerator(numBits,dataType,n,taps)
% generate uniform distributed random data or PRBS data
dataOut = zeros (numBits,1); 
if (nargin < 2)
    dataType = 'uniform';
end

if (nargin < 3)
    %generate prbs  parameters
    n = 7;
    taps = [7,6]; 
end

if (strcmp(dataType,'uniform'))
    %generate unform distributed random data
    %rng default % rng default will generate the same random pattern                                   % Use default random number generator
    dataOut = randi([0 1], numBits, 1);     % Generate vector of binary data  
elseif (strcmp(dataType,'prbs'))
  patternL = 2^n-1;
  if (numBits < patternL)
     dataOut = prbs(n, taps);      % generate prbs pattern, 
  else
     dataPattern = prbs(n,taps);      % pattern length N = 2^n-1
     N = round(numBits/patternL);
     for i = 0:(N-1)
         dataOut((i*patternL+1):(i+1)*patternL) = dataPattern;
     end
     dataOut(N*patternL+1:numBits) = dataPattern(1:(numBits-N*patternL));
  end
else
    error (' bitsGenerator () inputs error');
end
 
end