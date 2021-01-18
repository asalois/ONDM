%% Proakis Synthetic Channel Equilization

% Montana State University
% Electrical & Computer Engineering Department
% Created by Alexander Salois

% prelim comands
clear;
close all;

tic
%%
%load('Eqnet_test.mat');
% Define network
layers = [ ...
	featureInputLayer(18)
	fullyConnectedLayer(50)
	tanhLayer
	fullyConnectedLayer(50)
	tanhLayer
	fullyConnectedLayer(2)
	classificationLayer];

layers

toc

