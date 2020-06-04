#!/bin/bash
# run matlab sim
matlab -nodesktop -nodisplay -nosplash -r "fftw_test; exit;" >> test_out.txt
