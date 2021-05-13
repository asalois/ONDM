%% Proakis Synthetic Channel Equilization

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clear;
close all;
clc;

% Define network
layers = [ ...
    featureInputLayer(18)
    fullyConnectedLayer(50)
    tanhLayer
    fullyConnectedLayer(50)
    tanhLayer
    fullyConnectedLayer(2)
    regressionLayer];

% analyzeNetwork(layers)
for epochs = 10:10:150
    epochs
    samples = 4;
    SNR = 30;
    num_pow = 10;
    chunks = 2e3;
%     epochs = 100;
    val_size = floor(log2( (chunks * (2^num_pow)) /8 ));
    
    [data, target] = get_train_data(num_pow,SNR,samples);
    [val_data, val_target] = get_train_data(val_size,SNR,samples);
    
    train_data = zeros(size(data,1),size(data,2)*chunks);
    train_target = zeros(size(target,1),size(target,2)*chunks);
    
    for iter = 1:chunks
        train_data(:,((iter-1)*size(data,2)+1):(iter*size(data,2))) = data;
        train_target(:,((iter-1)*size(target,2)+1):(iter*size(target,2))) =  target;
        if iter ~= chunks
            [data, target] = get_train_data(num_pow,SNR,samples);
        end
    end
    
    miniBatchSize = 2^9;
    valFrequency = floor(size(train_data,2)/(2*miniBatchSize));
    options = trainingOptions('sgdm', ...
        'MiniBatchSize',miniBatchSize, ...
        'MaxEpochs',epochs, ...
        'Shuffle','every-epoch', ...
        'ValidationData',{val_data',val_target'}, ...
        'ValidationFrequency',valFrequency, ...
        'Verbose',false, ...
        'Plots','training-progress');
    
    net = trainNetwork(train_data',train_target',layers,options);
    
    % Test EQ
    [test_data, target] = get_train_data(15,SNR,samples);
    test = [target(1,:) + target(2,:)*1i]';
    % Test the Network
    output = predict(net,test_data')';
    output = [output(1,:) + output(2,:)*1i]';
    
    x = qamdemod(test,4);
    y = qamdemod(output,4);
    % find BER
    [~,berNN] = biterr(x,y)
    
    save('deepEQnet.mat','net')
end
