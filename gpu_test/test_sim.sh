#!/bin/bash
# run matlab sims 
for i in {1143..1180}
do
	echo "$i"
	matlab -nodesktop -nodisplay -nosplash -r "run_sims($i); exit;" >> out.txt
	echo "$i done"
done
