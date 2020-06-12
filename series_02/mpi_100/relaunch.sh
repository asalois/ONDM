#!/bin/bash
# to relaunch jobs
sbatch --array=0%0 qsmf.slurm
sleep 1
sbatch --array=53 qsmf_2.slurm
sleep 1
sbatch --array=206,303,363,436,521 qsmf_2.slurm
sleep 1
echo Done
