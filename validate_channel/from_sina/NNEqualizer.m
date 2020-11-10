function [Output_f] =NNEqualizer(Input_Signal,correct_output)

In = Input_Signal';
Tar = correct_output';
Eqnet = patternnet(1);

% Train the Network
[Eqnet,TT] = train(Eqnet,In,Tar);

% Test the Network
Output_f = Eqnet(In);


