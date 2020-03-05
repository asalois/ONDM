% test

tic
for l = 30
    bit_pwr = l
    run_to = 2^bit_pwr
    % serial test
    for i = 0:run_to
        i;
        x = i^2;
        y = i + i;
    end
end
toc
