#!/bin/bash
# script to organize the output and make new dir
(echo "jobs" && ls job_* -d | cut -d . -f 1 | cut -d _ -f 2 | sort -V) > jobs.csv
num=$(python3 /mnt/lustrefs/scratch/v16b915/scripts_hpc/give_me_jobs.py)
mkdir job_$num
mv qsmf_*.txt job_$num
cp qsmf_output* job_$num
mv qsmf_output* output/
