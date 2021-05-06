%% Proakis Synthetic Channel Equilization by ANN usiing LMLP

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois


%% Make EQ
% Define network
hLayers = 70; % hidden layer size4
Eqnet = fitnet(hLayers,'traingd'); % make a fitnet
Eqnet.layers{1}.transferFcn = 'purelin'; % have the actuvation be linear
Eqnet.trainParam.epochs = 10000;
Eqnet.trainParam.min_grad = 1E-8;

%% inital training
[train_data, target] = get_train_data(10,SNR);
% [Eqnet,TT] = train(Eqnet,train_data,target,'useParallel','yes'); % use when no gpu and small data
[Eqnet,TT] = train(Eqnet,train_data,target,'useGPU', 'yes'); % use when gpu
% [Eqnet,TT] = train(Eqnet,train_data,target); % use when no gpu and small data

%% Train in a Loop

for iter = 1:2000
    [train_data, target] = get_train_data(10,SNR);
    
    % Train the Network
%     [Eqnet,TT] = train(Eqnet,train_data,target,'useGPU', 'yes'); % use when gpu
    [Eqnet,TT] = train(Eqnet,train_data,target); % use when no gpu and small data
%     [Eqnet,TT] = train(Eqnet,train_data,target,'useParallel','yes'); % use when no gpu and large data
end
save Eqnet

%% Test EQ
[train_data, target] = get_train_data(20,snr);
test = [target(1,:) + target(2,:)*1i]';
% Test the Network
output = Eqnet(train_data);
output = [output(1,:) + output(2,:)*1i]';

x = qamdemod(test,4);
y = qamdemod(output,4);
% find BER
[~,berNN] = biterr(x,y)

