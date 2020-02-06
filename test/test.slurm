#!/bin/bash
#
#  Test Matlab job
#
# SBATCH -J MATLAB test run        # Job name
# SBATCH -o matlab_test-%j.txt # Standard Output output file (using same file for both)
# SBATCH -e matlab_test-%j.txt # Standard Error output file (using same file for both)
# SBATCH -p express   	# Queue name
# SBATCH -N 1        	# Total number of nodes requested (16 cores/node)
# SBATCH -n 1           # Total number of mpi tasks requested
# SBATCH --mem 32000 	# Megabytes of memory requested. Default is 2000/task.
# SBATCH -t 0-00:20:00  # Run time (day-hh:mm:ss) - 24 hrs
#
# Note: run 'man sbatch' to get more information for the options above.

date
echo "Hello from $(hostname)."

module load matlab/R2017a

echo "Run a matlab script"
time matlab -nodesktop -nodisplay -nosplash -r 'testwrapper; exit;'
time matlab -nodesktop -nodisplay -nosplash -r 'testwrapper_par; exit;'

echo "Ended batch processing at `date`."
