# This file will run similations with different parameters 

for i in 0..10
    for j in  0..10
        system("bash test.sh " + i.to_s + " " +j.to_s)
    end
end
