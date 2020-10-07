#!/bin/bash:wq
# to relaunch jobs
sbatch --exclude=compute015,compute072,compute073 --array=537-612 qsmf.slurm
echo Done
