#!/bin/bash
# to relaunch jobs
sbatch --array=16,17,126%45 qsmf.slurm
sleep 1
echo Done
