#!/bin/bash
# run matlab sims 
for i in {960..985}
do
	echo "$i"
	matlab -nodesktop -nodisplay -nosplash -r "run_sims($i); exit;"
done
