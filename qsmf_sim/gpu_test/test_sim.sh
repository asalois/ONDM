#!/bin/bash
# run matlab sims 
i=1300
echo "$i"
matlab -nodesktop -nodisplay -nosplash -r "run_sims($i); exit;" >> out.txt
echo "$i done"
