#!/bin/bash
# get and print inputs
# takes about 6 minutes to run on XPS laptop
echo "Run a matlab script"
time matlab -nodesktop -nodisplay -nosplash -r 'testwrapper; exit;'