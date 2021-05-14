%% Proakis Synthetic Channel Equilization

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clear;
close all;
clc;

SNR = 30;
deepnet = deepnnEq(SNR,1e3,50);
nnet = lmlpnnEq(SNR,100);

save('deepnet.mat','deepnet')
save('nnet.mat','nnet')

%% Test Deep NN
[test_data, target] = get_train_data(15,SNR,4);
test = [target(1,:) + target(2,:)*1i];
% Test the Network
output = predict(deepnet,test_data')';
output = [output(1,:) + output(2,:)*1i];

x = qamdemod(test,4);
y = qamdemod(output,4);
% find BER
[~,berDNN] = biterr(x,y)

%% Test Linear NN
[test_data, target] = get_train_data(15,SNR,14);
test = [target(1,:) + target(2,:)*1i];

% Test the Network
output = nnet(test_data);
output = [output(1,:) + output(2,:)*1i];
x = qamdemod(test,4);
y = qamdemod(output,4);
% find BER
[~,berNN] = biterr(x,y)

