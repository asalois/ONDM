#!/bin/bash
# to relaunch jobs
sbatch --array=52,55,56,57,60,64,65,69,70,71,95,96,103,104,105,107,108,109,110,111,112,114,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132%25 qsmf.slurm
sleep 1
echo Done
