#!/bin/bash
# script to organize the output and make new dir
matlab -nodesktop -nodisplay -nosplash -r "lmlp_nn;exit;"
matlab -nodesktop -nodisplay -nosplash -r "main;exit;"
