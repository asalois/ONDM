#!/bin/bash
# to relaunch jobs
sbatch --array=16,17,18,20,31,33,34,36,40,51,52,54,55,56,57,58,63,64,67,68,74,78,82,99,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132%45 qsmf.slurm
sleep 1
echo Done