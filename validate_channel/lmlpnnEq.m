function Eqnet = lmlpnnEq(SNR,loopTo)
%lmlpnneq Make and train an LMLP NN EQ
%   Detailed explanation goes here

% Define network
hLayers = 70; % hidden layer size4
Eqnet = fitnet(hLayers,'traingd'); % make a fitnet
Eqnet.layers{1}.transferFcn = 'purelin'; % have the actuvation be linear
Eqnet.trainParam.epochs = 10000;
Eqnet.trainParam.min_grad = 1E-8;

% inital training
[train_data, target] = get_train_data(10,SNR);
% [Eqnet,TT] = train(Eqnet,train_data,target,'useParallel','yes'); % use when no gpu and small data
[Eqnet,TT] = train(Eqnet,train_data,target,'useGPU', 'yes'); % use when gpu
% [Eqnet,TT] = train(Eqnet,train_data,target); % use when no gpu and small data

% Train in a Loop
for iter = 1:loopTo
    [train_data, target] = get_train_data(10,SNR);
    % Train the Network
    [Eqnet,TT] = train(Eqnet,train_data,target); % use when no gpu and small data
end

end

