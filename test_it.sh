#!/bin/bash
#
#  Test Matlab job
#
# SBATCH -J MATLAB test run        # Job name
# SBATCH -o matlab_test-%j.txt # Standard Output output file (using same file for both)
# SBATCH -e matlab_test-%j.txt # Standard Error output file (using same file for both)
# SBATCH -p express      # Queue name
# SBATCH -N 1            # Total number of nodes requested (16 cores/node)
# SBATCH -n 8           # Total number of mpi tasks requested
# SBATCH --mem 4000 #Megabytes of memory requested. Default is 2000/task.
# SBATCH -t 00:05:00     # Run time (hh:mm:ss) - 24 hrss
#
# Note: run 'man sbatch' to get more information for the options above.

date
echo "Hello from $(hostname)."

module load matlab/R2017a
 
time matlab -nodesktop -nodisplay -nosplash -r 'testwrapper; exit;'

echo "Ended batch processing at `date`."