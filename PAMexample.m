clc; % Clear Command Window
clear all; % clears  workspace
close all; % closes all figures

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% BPSK parameters
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nb=10; % Number of bits
Tb=1; % Bit period
Rb=1/Tb; % Bit rate
fc=2; % Carrier frequency
Tc=1/fc; % Carrier period
ns=32; % Number of samples per bit
fs=ns*Rb; % Sampling frequency
Ts=1/fs; % Sampling period
Ttot=nb*Tb; % Total simulation time

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate polar pseudo-random bit sequence
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pdata=2*(randi([0, 1], 1, nb)-0.5);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate a rectangular waveform
% recrectpulse(x,nsamp) applies rectangular pulse shaping to 
% x to produce an output signal having nsamp samples per symbol
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y = rectpulse(pdata,ns);

span = 10;        % Filter span in symbols
rolloff = 0.75;   % Roloff factor of filter
% Create a square-root, raised cosine filter using the rcosdesign function.

rrcFilter = rcosdesign(rolloff, span, ns);
% Display the RRC filter impulse response using the fvtool function.

fvtool(rrcFilter,'Analysis','Impulse')

txSignal = upfirdn(pdata, rrcFilter, ns, 1);

% The upfirdn function upsamples the modulated signal, dataMod, by a factor of numSamplesPerSymbol, 
%pads the upsampled signal with zeros at the end to flush the filter and then applies the filter.

% Set the Eb/N0 to 10 dB and convert the SNR given the number of bits per symbol, k, and the number of samples per symbol.

EbNo = 10;
snr = EbNo - 10*log10(ns);

%Pass the filtered signal through an AWGN channel.

rxSignal = awgn(txSignal, snr, 'measured');

%Filter the received signal using the square-root, raised cosine filter and remove a portion of the signal to account for the filter delay in order to make a meaningful BER comparison.

rxFiltSignal = upfirdn(rxSignal,rrcFilter,1,ns);   % Downsample and filter
rxFiltSignal = rxFiltSignal(span+1:end-span);                       % Account for delay

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generate plots
% subplot(m,n,p) divides the current figure into an m-by-n 
% grid and creates axes in the position specified by p.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t=0:Ts:Ttot-Ts; % Sampling the time axis
carrier=sin(2*pi*fc*t); % Generate the carrier

% Plot the binary sequence
figure ('NumberTitle', 'on', 'Name', 'Original signals');
subplot(2,1,1);
stem(pdata);
xlabel('Time (t/T_b)')
ylabel('Bits')
title('Pseuro-random binary sequence')


% Plot the carrier
subplot(2,1,2);
plot(t,carrier);
xlabel('Time (t/T_b)')
ylabel('c(t)')
title('Carrier')

figure ('NumberTitle', 'on', 'Name', 'How to create a PSK signal');
subplot(3,1,1);
plot(t,y);
xlabel('Time (t/T_b)')
ylabel('m(t)')
title('Binary waveform')


carrier=sin(2*pi*fc*t);
subplot(3,1,2);
plot(t,carrier);
xlabel('Time (t/T_b)')
ylabel('c(t)')
title('Carrier')

subplot(3,1,3);
plot(t,y.*carrier);
xlabel('Time (t/T_b)')
ylabel('s(t)')
title('PSK signal')

