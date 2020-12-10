%% Convert .csv to .mat for tensorflow

% close all; clear all; clc;

%% Load .csv files

% y = csvread('target.csv');
y = target';
% N = length(y)/2;
% y = reshape(y,N,2);
y(abs(y)<1e-10) = 0;

% x = csvread('data.csv');
x = data';
% x = reshape(x,N,58);
x(abs(x)<1e-10) = 0;

%% Randomly generate training, validation, and test data

PCT_TEST = 0.2;
PCT_VALID = 0.2;
N = length(y);

N_TEST = round(PCT_TEST*N);
N_VALID = round(PCT_VALID*N);
N_TRAIN = N - N_TEST - N_VALID;

idx_all = randperm(N);

idx_test = idx_all(1:N_TEST);
idx_valid = idx_all(N_TEST+1:N_TEST+N_VALID);
idx_train = idx_all(N_TEST+N_VALID+1:end);

x_test = x(idx_test,:);
y_test = y(idx_test,:);

x_valid = x(idx_valid,:);
y_valid = y(idx_valid,:);

x_train = x(idx_train,:);
y_train = y(idx_train,:);

%% Save!

save('tensorflow_comm','x_train','x_valid','x_test','y_train','y_valid','y_test');

%% Save a subset for debugging.

x_test = x_test(1:20000,:);
y_test = y_test(1:20000,:);

x_valid = x_valid(1:20000,:);
y_valid = y_valid(1:20000,:);

x_train = x_train(1:60000,:);
y_train = y_train(1:60000,:);

save('tensorflow_comm_debug','x_train','x_valid','x_test','y_train','y_valid','y_test');