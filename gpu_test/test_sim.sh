#!/bin/bash
# run matlab sims 
for i in {1039..1219}
do
	echo "$i"
	matlab -nodesktop -nodisplay -nosplash -r "run_sims($i); exit;" >> out.txt
done
