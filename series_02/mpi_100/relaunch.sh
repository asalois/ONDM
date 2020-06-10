#!/bin/bash
# to relaunch jobs
sbatch --array=0%20 qsmf.slurm
sleep 1
echo Done
