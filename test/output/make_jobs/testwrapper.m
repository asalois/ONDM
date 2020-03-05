% test

tic
for l = 6:28
    bit_pwr = l
    run_to = 2^bit_pwr
    % serial test
    for i = 0:run_to
        test_add(i, i);
        x = test_exponent(i, 4);
        test_divide(x,i);
    end
end
toc
