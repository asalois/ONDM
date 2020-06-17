#!/bin/bash
# to relaunch jobs
sbatch --array=1-1000 qsmf.slurm
sbatch --array=1-1000 qsmfAdd1000.slurm
sbatch --array=1-1000 qsmfAdd2000.slurm
sbatch --array=1-72 qsmfAdd3000.slurm
sleep 1
echo Done
