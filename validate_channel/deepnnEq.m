function net = deepnnEq(SNR,chunks, epochs)
%deepnnEq Make and train an Deep NN EQ
%   Detailed explanation goes here

% Define network
layers = [ ...
    featureInputLayer(18)
    fullyConnectedLayer(50)
    tanhLayer
    fullyConnectedLayer(50)
    tanhLayer
    fullyConnectedLayer(2)
    regressionLayer];

samples = 4;
num_pow = 10;
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

miniBatchSize = 2^8;
valFrequency = floor(size(train_data,2)/(2*miniBatchSize));
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',epochs, ...
    'Shuffle','every-epoch', ...
    'ValidationData',{val_data',val_target'}, ...
    'ValidationFrequency',valFrequency, ...
    'Verbose',true, ...
    'VerboseFrequency',valFrequency,...
    'Plots','none',...
    'ExecutionEnvironment','cpu');

net = trainNetwork(train_data',train_target',layers,options);
end
