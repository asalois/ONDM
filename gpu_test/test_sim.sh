#!/bin/bash
# find the files that outputted then make a script to relaunch jobs
for i in {931..948}
do
	echo "$i"
	matlab -nodesktop -nodisplay -nosplash -r "run_sims($i); exit;"
done
