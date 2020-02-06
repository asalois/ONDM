# This file will run similations with different parameters

for i in 0..10
    # system("bash test.sh " + i.to_s + " " +j.to_s)
    #system("matlab -nodesktop -nodisplay -nosplash -r 'test(" + i.to_s + "," + (i+2).to_s + "); exit;'")
    #t1 = Thread.new{system("bash test.sh " + i.to_s + " "+ (i+1).to_s )}
    #t2 = Thread.new{system("bash test.sh " + i.to_s + " "+ (i+2).to_s )}
    #t1.join
    #t2.join
    #fork{system("matlab -nodesktop -nodisplay -nosplash -r 'test(" + i.to_s + "," + (i+2).to_s + "); exit;'")}
    #fork{system("matlab -nodesktop -nodisplay -nosplash -r 'test(" + i.to_s + "," + (i+1).to_s + "); exit;'")}
    #fork{system("matlab -nodesktop -nodisplay -nosplash -r 'test(" + i.to_s + "," + (i+2).to_s + "); exit;'")}
    #fork{system("matlab -nodesktop -nodisplay -nosplash -r 'test(" + i.to_s + "," + (i+3).to_s + "); exit;'")}
    #fork{system("matlab -nodesktop -nodisplay -nosplash -r 'test(" + i.to_s + "," + (i+4).to_s + "); exit;'")}
    #Process.wait
end

system("matlab -nodesktop -nodisplay -nosplash -r 'testwrapper; exit;'")