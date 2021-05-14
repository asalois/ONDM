%% Proakis Synthetic Channel Equilization by ANN using LMLP

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois


%% Make EQ
snr = 30;
nnnet = lmlpnnEq(snr,100);
%% Test EQ
[train_data, target] = get_train_data(20,snr,14);
test = [target(1,:) + target(2,:)*1i];
% Test the Network
output = nnnet(train_data);
output = [output(1,:) + output(2,:)*1i];

x = qamdemod(test,4);
y = qamdemod(output,4);
% find BER
[~,berNN] = biterr(x,y)

