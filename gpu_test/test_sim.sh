#!/bin/bash
# run matlab sims 
for i in {986..994}
do
	echo "$i"
	matlab -nodesktop -nodisplay -nosplash -r "run_sims($i); exit;" >> out.txt
done
