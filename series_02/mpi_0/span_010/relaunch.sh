#!/bin/bash
# to relaunch jobs
sbatch --array=102 qsmf_test_1.slurm
sleep 1
sbatch --array=105 qsmf_test_1.slurm
sleep 1
sbatch --array=108 qsmf_test_1.slurm
sleep 1
sbatch --array=125 qsmf_test_1.slurm
sleep 1
sbatch --array=128 qsmf_test_1.slurm
sleep 1
sbatch --array=129 qsmf_test_1.slurm
sleep 1
echo Done
