#!/bin/bash
# get and print inputs

echo "Run a matlab script"
time matlab -nodesktop -nodisplay -nosplash -r 'testwrapper; exit;'
time matlab -nodesktop -nodisplay -nosplash -r 'testwrapper_par; exit;'