% test

for l = 8:32
    bit_pwr = l
    run_to = 2^bit_pwr

    % parallel test
    tic
    parfor i = 0:run_to
        test_add(i, i);
        x = test_exponent(i, 4);
        test_divide(x,i);
    end
    toc

    % serial test
    tic
    for i = 0:run_to
        test_add(i, i);
        x = test_exponent(i, 4);
        test_divide(x,i);
    end
    toc
end