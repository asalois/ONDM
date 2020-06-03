#!/bin/bash
# run matlab sim
matlab -nodesktop -nodisplay -nosplash -r "run_sims(1000); exit;" > benchmark_out.txt
