function [out] = test(in_exp)
% test

bit_pwr = in_exp
run_to = 2^bit_pwr
M = 1:run_to;
out = [uint64(M)', uint64(M'.^2), sqrt(M').*M'];
num = sprintf( '%03d', in_exp); 
file = "matlab_output_" + num + ".csv";
writematrix(out, file);

end

