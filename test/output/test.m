function [outputArg1] = test(inputArg1,inputArg2)
% test
outputArg1 = inputArg1 + inputArg2;
formatSpec =  '%d + %d = %d \n';
fprintf(formatSpec, inputArg1, inputArg2, outputArg1)
end

