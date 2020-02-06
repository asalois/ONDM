% test
for i = 0:2^32
    test_add(i, i);
    x = test_exponent(i, 4);
    test_divide(x,i);
end