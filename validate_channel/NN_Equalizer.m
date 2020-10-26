clear all; clc;

tic
% BPSK modulation order
M = 2;

%Define the channel
Rchannel = 1/sqrt(2)*[randn(1,M+1) + 1i*randn(1,M+1)];

%BPSK modulator
Mod_BPSK = comm.BPSKModulator;

%BPSK demodulator
Demod_BPSK = comm.BPSKDemodulator;

% Random bit stream
TRSignal = randi([0 M-1],500,1);

% BPSK modulated signal
BPSKSignal = step(Mod_BPSK, TRSignal);
S = zeros(size(BPSKSignal));
for i=1:length(BPSKSignal)
    if BPSKSignal(i) == 1.0000+0.0000i
        S(i) = 1;
    else
        S(i) = -1;
    end
end

correct_output=zeros(500, 2);
c_out = eye(M)
for i=1:length(BPSKSignal)
    if S(i) == 1
        correct_output(i,:) = c_out(1,:);
    else
        correct_output(i,:) = c_out(2,:);
    end
end

% Filter the channel
Channel_effect = filter(Rchannel,1,BPSKSignal);

%SNR range
SNR = 0:1:20;
SNR_Num = length(SNR);

% Create an AWGN Channel
AWGN_Channel = comm.AWGNChannel('NoiseMethod', 'Signal to noise ratio (SNR)');

%Preallocate BER and equalized BER
BER_Val = zeros(3, SNR_Num);
Equalized_BER=zeros(SNR_Num,1);

% Calculate error rate
Error_Cal = comm.ErrorRate;

%BER and equalized BER calculation
for n = 1:SNR_Num
    AWGN_Channel.SNR = SNR(n);
    Rec_Signal = step(AWGN_Channel,Channel_effect);
    Rec_Bit = step(Demod_BPSK, Rec_Signal);
    Input_Signal = [real(Rec_Signal), imag(Rec_Signal)];
    reset(Error_Cal)
    BER_Val(:,n) = step(Error_Cal,TRSignal,Rec_Bit);
    Model_Output=NNEqualizer(Input_Signal,correct_output);
    [vv,uu]=max(Model_Output);
    NN=(uu==1);
    FSig = step(Demod_BPSK, 2*double(NN')-1);
    Equalized_BER(n)=sum(abs(TRSignal-FSig))/500;
end
BER = BER_Val(1,:);

%  Plot BER vs. SNR
figure;
semilogy(SNR,BER,'b*-',SNR,Equalized_BER,'r+-');
xlabel('SNR (dB)');
ylabel('BER');
legend('Without Equalization','Equalized');
grid on

toc
