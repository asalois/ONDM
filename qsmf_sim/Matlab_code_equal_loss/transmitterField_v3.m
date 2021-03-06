% generate a 16-QAM modulated signal with Gray code mapping and squared
% raised cosine filter 
function [txData,txSignal] = transmitterField_v3(dataTemplate,filter, numBits,numDelayInSymbol,power,figureDisplayFlag)
%% set the simulation variables
M = dataTemplate.M;  %16               % Size of signal constellation
k = log2(M);                           % Number of bits per symbol
% numSymbols = 2^12;                   % Number of symbols to process
%numBits = k*numSymbols; % 1e6;         % Number of bits to process
samplesPerSymbol = filter.samplesPerSymbol; %32;  % Oversampling factor

if (nargin <6)
    figureDisplayFlag = 'no';
end

if(nargin < 5)
    powerSetFlag = 'no';  % no power setting
elseif(power<0)
    powerSetFlag = 'no';   
else
    powerSetFlag = 'yes';
end

if (nargin <4)
    numDelayInSymbol = randi([30,100]);  % generate a random delay in [30, 100]
end

%% setting raised cosine filtering
if(isempty(filter.Hf))   % if filter Hf is not provided, create a filter
    span = filter.spanInSymbols;  %32;        % Filter span in symbols
    rolloff = filter.rolloff; %0.01;   % Roloff factor of filter

    rrcFilter = rcosdesign(rolloff, span, samplesPerSymbol);  % create the square root raised cosine filter
else 
    rrcFilter = filter.Hf;
end

if (strcmp(figureDisplayFlag,'yes'))
    % display the filter impulse response
    fvtool(rrcFilter,'Analysis','Impulse')  %figure 1
end

%% generate random or pesdorandom binary sequence
if (strcmp(dataTemplate.type,'prbs'))
    % generate PRBS binary data
    n = dataTemplate.prbs.n; %12;                  
    taps = dataTemplate.prbs.taps; %[12, 9, 8, 5];   
    % common prbs pattern: 
                    % n = 7   [7,6];  
                    % n = 9   [9,5]
                    % n = 11   [11, 9]
                    % n = 12  [12, 9, 8, 5] 
                    % n = 14  [14, 13, 10, 9]
                    % n = 15  [15,14][15,4]
                    % n = 20  [20, 3]
                    % n = 23  [23,18] 
                    % n = 31  [31,28]
    dataPattern = prbs(n,taps);      % pattern length N = 2^n-1, initial data is random selected
    dataPattern = circshift(dataPattern, numDelayInSymbol);  %  shift
    dataIn0 = repmat(dataPattern,1,k);  % concatenate k x dataPattern
    dataIn = [dataIn0,zeros(1,k)]';   % pad k of zero at the end and change to column vector
elseif (strcmp(dataTemplate.type,'prss'))
    % generate PRSS symbol and corresponding binary data
   load('prss4096.mat');
   dataSymbolsIn = Expression1;
   dataSymbolsIn = circshift(dataSymbolsIn, numDelayInSymbol);  %  shift
   dataInMatrix = de2bi(dataSymbolsIn,k);
   dataIn = dataInMatrix(:);                 % Return data in column vectorelse
else
   % generate uniform distributed binary data
   dataIn = randi([0 1], numBits, 1);     % Generate vector of binary data  
end

if (strcmp(figureDisplayFlag,'yes'))
    % polt the first 40 bits in a stem plot
    figure('Name','First 40 bits');    % figure 2
    stem(dataIn(1:40),'filled');
    title('Random Bits');
    xlabel('Bit Index');
    ylabel('Binary Value');
end

%% mapping data
if (~strcmp(dataTemplate.type,'prss'))   % generate symbol for prbs and uniform pattern
    dataInMatrix = reshape(dataIn, ...
    length(dataIn)/k, k);                      % Reshape data into binary 4-tuples
    dataSymbolsIn = bi2de(dataInMatrix);           % Convert to integers
end

if (strcmp(figureDisplayFlag,'yes'))
    % plot the first 10 symbols
    f2 = figure;                             % create a new figure, figure 3
    title('First 20 symbols'); 
    stem(dataSymbolsIn(1:20));
    title('Random Symbols');
    xlabel('Symbol Index');
    ylabel('Integer Value');
end

%% modulate data with square root raised cosine filter
% dataMod = qammod(dataSymbolsIn,M,'bin');         % Binary coding, phase offset = 0
dataMod = qammod(dataSymbolsIn,M);       % Gray coding (default), phase offset = 0

% pass the filter
txSignal = upfirdn(dataMod, rrcFilter, samplesPerSymbol, 1);  % pulse shaping
% the output data size of upfirdn is ceil(((Lx-1)*P+Lh))/Q,
% where Lx, Lh is the length of input data and length (order) of the filter
% P, Q are the upsampling and downsampling factor

% set output power
if (~strcmp(powerSetFlag,'no'))
   % Calibrate the power
Lh = length(rrcFilter); %  filter length
Lh2 = (Lh-1)/2;   % half of filter length
txSignal0 = txSignal(Lh2+1:end-Lh2);  % remove the extra data generated by filter 
Ptx0 = sum(abs(txSignal0).^2)/length(txSignal0);
% Ptx = sum(abs(txSignal).^2)/length(txSignal);
% r = sqrt (Ptx0/Ptx);   % power ratio
% txSignal = txSignal./sqrt(Ptx)*sqrt(power); % set output power
txSignal = txSignal./sqrt(Ptx0)*sqrt(power); % set output signal power calibrated
end
txData = dataIn;   % return binary sequence

