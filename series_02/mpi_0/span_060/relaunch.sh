#!/bin/bash
# to relaunch jobs
sbatch --array=33,34,35,36,39,40,41,51,52,54,55,56,57,58%40 qsmf.slurm
sleep 1
echo Done
