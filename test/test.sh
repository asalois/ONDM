#!/bin/bash
# get and print inputs
# takes about 4.5 minutes to run on XPS laptop
echo "Run a matlab script"
time matlab -nodesktop -nodisplay -nosplash -r 'testwrapper; exit;'
#time matlab -nodesktop -nodisplay -nosplash -r 'testwrapper_par; exit;'