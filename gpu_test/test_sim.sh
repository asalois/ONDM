#!/bin/bash
# find the files that outputted then make a script to relaunch jobs
matlab -nodesktop -nodisplay -nosplash -r "run_sims(1000); exit;"

