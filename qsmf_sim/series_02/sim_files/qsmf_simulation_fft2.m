%% JX_16QAM_v8 is a sample code develped on January, 2019
%  by JX on R2017b 
%
%  - New feature: v8 set the Nfft = 524288 ( power of 2)
%  (apply only to uniform data with 15872 symbols) to reduce the
%  calculation time by about 45%
%
%  - Feature summary: Support the following cases: 
%           PDM optical signal, WDM channels, 
%           Multiple regular single fiber spans,
%           ideal constant gain amplifiers, 
%           accumulate CD is removed by a pseudofiber,
%           no PMD, 
%  requires:   matlab communication system toolbox and 
%      prbs.m, bitsGenerator.m, transmitterField_v3.m 
%      create_uniqueFiled.m, setChannelWavelengths.m 
%      hybrid_span_v1.m, phaseEqualizer_v1.m,getSignalPower.m, getSignalPower_v1
%      createDirectoryForResults.m, 
% JX_16QAM_v8 support uniform, PRBS, and PRSS pattern.  The data
% sequences is generated once and then set them into different power and
% pass through the fiber link. hybrid_span_v1.m support hybrid fiber span
% with first segement span is QSM with MPI and second span is regular SMF.
% MPI is added at the end of fiber link. TransmitterField_v3 supports
% PRSS4096, PRBS, and uniform pattern and calibrates the transmiting data
% power to 1 mW ( excluding the extra samples generated by filter).
%
% 
function  QdB = qsmf_simulation_fft2(indx, in_power, in_span, in_seg_len, in_r, in_alpha1, in_alpha2, in_aeff1, in_aeff2)

% clear all
% close all
% clc
% 
% folder = createDirectoryForResults();

tic;   % start  a timer
laserPowerdBmArray = in_power;  %-45.96:1.05:-30.96;   % Laser power [dBm] 
%laserPowerdBm = 0  % Laser power [dBm}
totalLength = 6000;   % total transmission length [km]
spanLength = in_span;   % span length [km]
segmentLength_1 = in_seg_len;  % first segement length,must < spanLength [km]
nblocksP = 32;  % phase equalizer nblockP, power of 2
Nch = 9;   % WDM channels, must be an odd number
dataType = 'uniform';    % random data type, 'uniform' or 'prbs',ot 'prss',  prss pattern only support symbol length of 4096
MPIflag = 'yes';   % include MPI crosstalk or not - 'yes' or 'no'
percComp = in_r;    % percentage of MPI compensation.  0 - full MPI, 100 - MPI fully compensated
stepLength = 150; % 250;  % fiber step length  [m]

fiberAeff_1 = in_aeff1;   % QSM fiber effective area   [um^2]
fiberAeff_2 = in_aeff2;   % EX3000 fiber effective area   [um^2]
fiberAlphadB_1 = in_alpha1;  % QSM fiber attenuation [dB/km]
fiberAlphadB_2 = in_alpha2;  % EX3000 fiber attenuation [dB/km]

%% set simulation variables

clearvars dataTemplate filter modulation data link ;

        modulation.type = 'QAM';                % So far it can only be QAM
        modulation.M = 16;                      % Size of signal constellation
        modulation.constellationDis = 2;        % Distance between constellation points, default is 2
       
        data.symbolRate = 32e9;                 % Symbol rate in baud [baud = symbols/s]
        lambda0 = 1550;          % central chanel wavelength [nm]      
       
        % binary data parameters
        dataTemplate.M = modulation.M ;              % Size of signal constellation
        dataTemplate.type = dataType;%'uniform';% 'prbs';   random data type: prbs or uniform (default) 
        bitPerSymbol = log2(modulation.M);                     % Number of bits per symbol
        if (strcmp(dataType,'uniform')) 
            data.numSymbols =2^14-512;   % Number of symbols to be sent;  512 is the length in symbols of filter
        elseif(strcmp(dataType, 'prbs'))
            dataTemplate.prbs.n = 14;                   % prbs 
            dataTemplate.prbs.taps = [14, 13, 10, 9];     
                    % n = 7   [7,6];  
                    % n = 9   [9,5]
                    % n = 11   [11, 9]
                    % n = 12  [12, 9, 8, 5] 
                    % n = 14  [14, 13, 10, 9]
                    % n = 15  [15,14][15,4]
                    % n = 20  [20, 3]
                    % n = 23  [23,18] 
                    % n = 31  [31,28]
            data.numSymbols = 2^dataTemplate.prbs.n ;      % send 2^n symbol out (not 2^n -1)  
        elseif (strcmp(dataType, 'prss'))
            data.numSymbols = 2^12;     % Number of symbols to be sent, only support 4096
        else
            error('Data pattern error - only support uniform, prbs, or prss pattern');
        end
        %squre root raised cosine filtering
        filter.spanInSymbols = 512;        % Filter span in symbols
        filter.rolloff = 0.01;   % Roloff factor of filter
        filter.samplesPerSymbol = 32; % Oversampling factor
        data.samplesPerSymbol = filter.samplesPerSymbol;  % Samples per symbol
        % should be power of 2
       
       
        %%%%%%%%%%%%%%%% Fiber Link parameters
        link.dispInLine = 0;                    % in-line dispersion x span [ps/nm]
        link.fiber1.numberSpans = totalLength/spanLength;           % Number of spans to be simulated
        link.lambda = 1550;                     % Center channel Wavelength [nm]
        link.numberChannels = Nch;                % Number of channels
      
        %%%%  Fiber 1 - first semgement, fiber type - QSM, EX 3000 
        link.fiber1.length_1  = segmentLength_1;    %first segment Length [km], must < spanLength 
        link.fiber1.alphadB_1 = fiberAlphadB_1;   %QSM&EX3000 0.155      % Attenuation [dB/km]
        link.fiber1.aeff_1    = fiberAeff_1; % EX3000 150; % QSM 200; 220;%150;%80;   % Effective area [um^2]
        link.fiber1.n2_1      = 2.1e-20; % QSM&EX3000 2.1071e-20;%2.3337e-20?;2.5656e-20; [m^2/W]       % Nonlinear index [m^2/W]
        link.fiber1.lambda_1  = 1550;              % Wavelength [nm] @ dispersion 
        link.fiber1.disp_1    = 20.855;%16.5;QSM&EX3000 20.855   % Dispersion [ps/nm/km] @ wavelength
        link.fiber1.slope_1   = 0;                 % Slope [ps/nm^2/km] @ wavelength
        link.fiber1.dphimax_1 = 1e-3;%pi/360;          % Maximum nonlinear phase rotation per step
        link.fiber1.dzmax_1   = 0.25e4;   %100            % Maximum SSFM step 
        link.fiber1.steplength_1 = stepLength;           % Step length [m]
        link.fiber1.flag_1    = 'g-sx';            % Flag for activate fiber effects 'gpsx'
        %link.fiber1.manakov_1 = 'no';
        
         % Fiber 1 - high order mode MPI crosstalk
        link.fiber1.MPI.useCrosstalk = MPIflag;      % for including crosstalk or not
        link.fiber1.MPI.percComp = percComp; % 0;    % Percentage of MPI compensation, 
                                                   % 0 -> no MPI compensation, 100 --> 100 % compensation
        link.fiber1.MPI.deltaAlpha = 2;            % Differential attenuation [dB/km]
        link.fiber1.MPI.kappa = 1e-3;              % coupling coefficient 1/km
   
        
        %%%%  Fiber 1 - 2nd segment, fiber type - EX 3000 or other SMF
        link.fiber1.length_2  = spanLength-link.fiber1.length_1;    %2nd segment Length [km], must < spanLength 
        link.fiber1.alphadB_2 = fiberAlphadB_2;  %QSM&EX3000 0.155             % Attenuation [dB/km]
        link.fiber1.aeff_2    = fiberAeff_2; % EX3000 150; % QSM 200; 220;%150;%80;   % Effective area [um^2]
        link.fiber1.n2_2      = 2.1e-20; % QSM&EX3000 2.1071e-20;%2.3337e-20?;2.5656e-20; [m^2/W]       % Nonlinear index [m^2/W]
        link.fiber1.lambda_2  = 1550;              % Wavelength [nm] @ dispersion 
        link.fiber1.disp_2    = 20.855;%16.5;QSM&EX3000 20.855   % Dispersion [ps/nm/km] @ wavelength
        link.fiber1.slope_2   = 0;                 % Slope [ps/nm^2/km] @ wavelength
        link.fiber1.dphimax_2 = 1e-3;%pi/360;          % Maximum nonlinear phase rotation per step
        link.fiber1.dzmax_2   = 0.25e4;   %100            % Maximum SSFM step 
        link.fiber1.steplength_2 = stepLength;           % Step length [m]
        link.fiber1.flag_2    = 'g-sx';            % Flag for activate fiber effects 'gpsx'
       % link.fiber1.manakov_2 = 'no';
     
        % Amplification Fiber 1
        link.fiber1.useAmplification = 'yes';   % Use or not amplification after this second fiber.
        link.fiber1.amplification = 'gain';      % 'gain'  - constant gain amplifier
        link.fiber1.amplifier.noiseFig = 5;%13;      % ASE noise figure of the amplifier in dB

       
        
        % Phase Equalizer NOT WORKING AS A PARAMETERS
        PE.nphasesP = 100;              % 
        PE.nblocksP = nblocksP;          % must be power of 2
              
%% generate transmitter data

    % generate randome binary data sequence
    numSymbols = data.numSymbols;                % Number of symbols to process
    numBits = numSymbols*bitPerSymbol; %1e6;                    % Number of bits to process

    % generate filter Hf 
    span = filter.spanInSymbols;
    rolloff = filter.rolloff;
    samplesPerSymbol = filter.samplesPerSymbol;
    rrcFilter = rcosdesign(rolloff, span, samplesPerSymbol);  % create the square root raised cosine filter
    filter.Hf = rrcFilter;
    Lh = length(filter.Hf);  % filter length in samples

    % initial arrays for error bits and ber
    L = length(laserPowerdBmArray);    
    finalnumErrorsX = zeros(1,L);
    finalnumErrorsY = zeros(1,L);
    finalberX = zeros(1,L);
    finalberY = zeros(1,L);

 % create modulated data
    rng shuffle;    % seeds the random number generator based on the current time.
    figureDisplayFlag = 'no';   % yes - display figures
    numDelayInSymbolX = randi([0,10]);      %  symbol delay,  for prbs and prss pattern
    numDelayInSymbolY = randi([57,67]);
    
    laserPowerPerPol = 1;    % set output power to be 1 mW
    [txDataX,txSignalX0] = transmitterField_v3(dataTemplate,filter, numBits, numDelayInSymbolX,laserPowerPerPol,figureDisplayFlag);
    [txDataY,txSignalY0] = transmitterField_v3(dataTemplate,filter, numBits, numDelayInSymbolY,laserPowerPerPol,figureDisplayFlag);
      
    tx_power_dBm_no_calibration = getSignalPower(txSignalX0,txSignalY0);
        
    % create WDM channels
    Nfft0 = length(txSignalX0);
    Nfft = Nfft0+31;     % modified Nfft to be 524,288 (power of 2)
    txSignalX = zeros(Nfft,Nch);
    txSignalY = zeros(Nfft,Nch);
    fs = data.symbolRate/filter.samplesPerSymbol;
    ts = 1/fs;     
  
   for n = 1: Nch
            if n == (Nch+1)/2   % central channel
                txSignalX(1:Nfft0,n) = txSignalX0;
                txSignalY(1:Nfft0,n) = txSignalY0;
            else
               numDelayInSymbolX = randi([11,50]);      %  symbol delay, for prbs and prss pattern
               numDelayInSymbolY = randi([70,110]);
              [txDataXn,txSignalXn] = transmitterField_v3(dataTemplate,filter, numBits, numDelayInSymbolX,laserPowerPerPol,figureDisplayFlag);
              [txDataYn,txSignalYn] = transmitterField_v3(dataTemplate,filter, numBits, numDelayInSymbolY,laserPowerPerPol,figureDisplayFlag);
              txSignalX(1:Nfft0,n) = txSignalXn;
              txSignalY(1:Nfft0,n) = txSignalYn;
            end
   end
    
        
  for m = 1:length(laserPowerdBmArray)
         %set the signal power 
         laserPowerdBm = laserPowerdBmArray(m);
         laserPower = 10^(laserPowerdBm/10);  % laser power in mW
         laserPowerPerPol = laserPower/2;   % laser power in one pol.
    
        % Set signal power to desire power 
        
        txSignalXm = txSignalX*sqrt(laserPowerPerPol);
        txSignalYm = txSignalY*sqrt(laserPowerPerPol); 
             
% Calculating normalized frequencies
        
     stepf = samplesPerSymbol/length(txSignalXm(:,1)); 
        % inverse of the number of symbols sent in simulation.ts seconds 
     data.normalizedFreq = fftshift(-data.samplesPerSymbol/2:stepf:data.samplesPerSymbol/2-stepf);
       % Frequency normalized to the symbol rate (R),

% WDM Mux
         sigx = txSignalXm;
         sigy = txSignalYm;
         link.channelsSpacingHz = (1+filter.rolloff)*data.symbolRate;%1.01*data.symbolRate;         % Distance between channels [Hz]
         link.channelWavelengths = setChannelWavelengths(link.lambda,...
                              link.channelsSpacingHz, link.numberChannels);

%% create an unique electric field for WDM optical signals
     symbolRate = data.symbolRate;
     channelWavelength = link.channelWavelengths;  
     normalizedFreq = data.normalizedFreq;   
    [fieldX,fieldY,delay,dispersion] = create_uniqueField(sigx,sigy,...
           samplesPerSymbol,symbolRate,channelWavelength,normalizedFreq);
  %     fvtool(txSignalX0);
  %     fvtool(fieldX);
     
    figFlag1 = 'no';
    if (strcmp(figFlag1,'yes'))
    % plot the first 10 symbols
    f2 = figure;                             % create a new figure, figure 3
    title('First 20 symbols'); 
    stem(fieldX(1000:1250));
    title('Random Symbols');
    xlabel('Symbol Index');
    ylabel('Integer Value');
    end
    
      
 %% pass a hybrid fiber link with dispersion removed by an ideal negative dispersion fiber   
   % power_before_fiber_dBm = getSignalPower(fieldX,fieldY);
    %power_before_fiber_dBm_Ch = power_before_fiber_dBm - 10*log10(Nch);

    [outFieldX,outFieldY,noise] = hybrid_span_v1(fieldX,fieldY,...
        link,symbolRate, samplesPerSymbol,Lh,normalizedFreq);

    % power_after_fiber_dBm = getSignalPower(outFieldX,outFieldY);
    % power_after_fiber_dBm_Ch = power_after_fiber_dBm -10*log10(Nch);
    
    rxSignalX = outFieldX(1:Nfft0);  
    rxSignalY = outFieldY(1:Nfft0);
    rxSignal = [outFieldX, outFieldY];  % combined as one PDM signal

% display constellation diagram
    figFlag2 = 'no';
        if (strcmp(figFlag2,'yes'))
          sPlotFig = scatterplot(sqrt(samplesPerSymbol)*rxSignalX,1,0,'g.');   % figure 4
          hold on
          M = dataTemplate.M;
          dataSamp =(0:M-1)';
          dataModSamp = qammod(dataSamp,M);  
          scatterplot(dataModSamp,1,0,'k*',sPlotFig)
          title('Received Signal after the channel X-pol.');
       end
%% Receive and demodulate signal

rxFiltSignal_1 = upfirdn(rxSignal,rrcFilter,1,samplesPerSymbol);   % Downsample and filter
rxFiltSignal = sqrt(samplesPerSymbol)*rxFiltSignal_1(span+1:end-span,:);% Account for delay

%fvtool(rxFiltSignal);

% normalized received signal power 
M = dataTemplate.M;
dataSamp =(0:M-1)';
dataModSamp = qammod(dataSamp,M);
dataModSampPower = sum(abs(dataModSamp).^2)/length(dataModSamp);
[lengthrxFiltSignal, numPol]=size(rxFiltSignal);
rxFiltSignalPower = sum(abs(rxFiltSignal).^2)/lengthrxFiltSignal;
r = sqrt(dataModSampPower)./sqrt(rxFiltSignalPower);

rxFiltSignal = rxFiltSignal.*r;

rxFiltSignalX = rxFiltSignal(:,1);
rxFiltSignalY = rxFiltSignal(:,2);

 figFlag3 = 'no';
    if (strcmp(figFlag3,'yes'))
    % plot the first 10 symbols
     f2 = figure;                             % create a new figure, figure 3
     title('First 20 symbols'); 
     stem(sqrt(Nch)*rxFiltSignal(1:100));
     title('Random Symbols');
     xlabel('Symbol Index');
     ylabel('Integer Value');
    end


 figFlag4 = 'no';
   if (strcmp(figFlag4,'yes'))
    sPlotFig = scatterplot(rxFiltSignalX,1,0,'g.');   % figure 4
    title('Received Signal After Filtering - X pol.');

    sPlotFig = scatterplot(rxFiltSignalY,1,0,'g.');
    title('Received Signal After Filtering -Y pol.');
   end


%% Phase equalization
filterSpan = filter.spanInSymbols;

PEOutputX = phaseEqualizer_v1(rxFiltSignalX,PE.nphasesP,PE.nblocksP);
PEOutputY = phaseEqualizer_v1(rxFiltSignalY,PE.nphasesP,PE.nblocksP);

PEOutputX = sqrt(samplesPerSymbol)/2*PEOutputX;
PEOutputY = sqrt(samplesPerSymbol)/2*PEOutputY;

   figFlag5 = 'no';
    if (strcmp(figFlag5,'yes'))
        scatterplot(PEOutputX(1:min(5e3,length(PEOutputX))),1,0,'b.');
        title(' Received Signal, after Phase Equalizer - X pol.');
        axis([-5 5 -5 5]); % Set axis ranges
        hold off;
    end
    
%% Demodulation of the signal
initialPhase = [0,pi/2,-pi/2,pi];     %  phase shift
finalOutputX = exp(-1i*initialPhase).*PEOutputX;  %  add intial phase shift
finalOutputY = exp(-1i*initialPhase).*PEOutputY; 

M = dataTemplate.M;
dataSymbolsOutX = qamdemod(finalOutputX, M);  % demodulate the signal with different phase shifts
dataSymbolsOutY = qamdemod(finalOutputY, M);

k = log2(M);
for i = 1:4
    
dataOutMatrixX = de2bi(dataSymbolsOutX(:,i),k);    % de2bi converts a nonnegative decimal integer to a binary row vector
dataOutX(:,i) = dataOutMatrixX(:);                 % Return data in column vector

dataOutMatrixY = de2bi(dataSymbolsOutY(:,i),k);    % de2bi converts a nonnegative decimal integer to a binary row vector
dataOutY(:,i) = dataOutMatrixY(:);                 % Return data in column vector
end      


%% BER calculation                          

[numErrorsX, berX]= biterr(dataOutX, txDataX); 
[numErrorsY, berY]= biterr(dataOutY, txDataY); 

finalnumErrorsX(1,m) = min(numErrorsX);
finalnumErrorsY(1,m) = min(numErrorsY);
finalberX(1,m) = min(berX);
finalberY(1,m) =  min(berY);

figFlag6 = 'no';
if (strcmp(figFlag6,'yes'))
    h = scatterplot(sqrt(samplesPerSymbol)*...         % figure 6
    rxSignalX(1:min(samplesPerSymbol*5e3,length(rxSignalX))),...
         samplesPerSymbol,0,'g.');
    hold on;
    scatterplot(rxFiltSignalX(1:min(5e3,length(rxFiltSignalX))),1,0,'kx',h);
    title('Received Signal, Before and After Filtering - X pol.');
    legend('Before Filtering','After Filtering');
    axis([-5 5 -5 5]); % Set axis ranges
    hold off;
end
% save the tx data

% filename=strcat(folder,'\txdata_',num2str(m),'_',num2str(laserPowerdBm),'dBm.xlsx');
% dataTable=table(txDataX,txDataY);
% writetable(dataTable, filename);   

% minErrors = length(dataOut);
% index = 1;
% 
% for i = 1:floor(length(dataOut)/4)
%      [numErrors, ber] = ...
%    biterr(txData(1:end-decDelay),dataOut(decDelay+1:end));       
%     if (minErrors > numErrors)
%         minErrors = numErrors;
%         index = decDelay;
%     end
%       decDelay = decDelay +1;
% end
% 
% dataOut = circshift(dataOut, index);  % align the delay
% [numErrors, ber] =  biterr(txData,dataOut);      
% 
     end
% fprintf('\nThe laser launch power per channel = %5.2e dBm\n', ...
%     laserPowerdBm);
% fprintf('\nThe X.pol. bit error rate = %5.2e, based on %d errors\n', ...
%     finalberX, finalnumErrorsX);
% fprintf('\nThe Y.pol. bit error rate = %5.2e, based on %d errors\n', ...
%     finalberY, finalnumErrorsY);
%   
    

% visualization of Filter effects
% eyediagram(txSignal(1:min(5000,length(txSignal))),samplesPerSymbol*2);  % figure 5

% display a scatter plot of received signal before and after the filtering
% Notice that the first scatterplot command scales rxSignal by
% sqrt(numSamplesPerSymbol) when plotting. This is because the filtering
% operation changes the signal's power.

% calculate Q
Qx = sqrt(2).*erfcinv(finalberX.*2);
Qy = sqrt(2).*erfcinv(finalberY.*2);
Q = sqrt(2).*erfcinv(finalberX+finalberY);

QxdB = 20*log10(Qx);
QydB = 20*log10(Qy);
QdB = 20*log10(Q);
[laserPowerdBmArray QdB]

figFlag7 = 'no';
if (strcmp(figFlag7,'yes'))
    plot(laserPowerdBmArray,QxdB,'--o')
    hold on
    plot(laserPowerdBmArray,QydB,'-o')
    plot(laserPowerdBmArray,QdB,'-x')
    title('Q vs launch power')
    xlabel('launch power (dBm)')
    ylabel('Q (dB)')
    grid on
    legend('X field curve','Y field curve','mean curve')
    hold off
end

out = [QdB, laserPowerdBmArray, segmentLength_1, percComp, fiberAeff_1, fiberAeff_2, fiberAlphadB_1, fiberAlphadB_2, spanLength];
file = "qsmf_output_" + indx + ".csv";
csvwrite(file, out);
toc;    % stop the timer 
%% Write data into Excel file
% timeChar = char(datetime('now','Format','MMM_d_y_HH_mm_ss'));
% filename=strcat(folder,'\results_',timeChar,'.xlsx');
% dataTable=table(laserPowerdBmArray',QdB');
% writetable(dataTable, filename);   
end
