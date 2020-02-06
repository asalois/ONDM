#!/bin/bash
#
#  Mathematica batch job
#
# SBATCH -J parallel_matlab_test        # Job name
# SBATCH -o parallel_matlab_test-%j.txt # Standard Output output file (using same file for both)
# SBATCH -e parallel_matlab_test-%j.txt # Standard Error output file (using same file for both)
# SBATCH -p unsafe
# SBATCH -p express      # Queue name
# SBATCH -N 1            # Total number of nodes requested (16 cores/node)
# SBATCH -n 2           # Total number of mpi tasks requested
# SBATCH -n 12           # Total number of mpi tasks requested
# SBATCH -N 2            # Total number of nodes requested (16 cores/node)
# SBATCH -n 1            # Total number of mpi tasks requested
# SBATCH --mem 4000 #Megabytes of memory requested. Default is 2000/task.
# SBATCH --mem 24000 #Megabytes of memory requested. Default is 2000/task.
# SBATCH --mem 256000 # Megabytes of memory requested. Default is 2000/task.
# SBATCH -n 1            # Total number of mpi tasks requested
# SBATCH -t 24:00:00     # Run time (hh:mm:ss) - 24 hrs
# SBATCH -t 40:00:00     # Run time (hh:mm:ss) - 24 hrs
# SBATCH -t 00:30:00     # Run time (hh:mm:ss) - 24 hrs
# SBATCH -t 5 # Runtime in days-hours:minutes:seconds. 
# SBATCH -t 15     # Run time (hh:mm:ss) - 24 hrs
## 
# SBATCH --mail-user ioannis.roudas@montana.edu # user to send emails to
# BATCH --mail-type ALL                    # (equivalent to  BEGIN,  END,  FAIL  and REQUEUE)
#
# Note: run 'man sbatch' to get more information for the options above.

# date
# echo "Hello from $(hostname)."

date

# module load mathematica/11.0.1
module load matlab/R2017a
 
echo "Information about the job:"

# run mathematica in command line mode 
# math  -noprompt -run < BenchmarkProgram.m
# math  -noprompt -run < sample-parallel-new.m
# math  -noprompt -run < matrixInversion.m
# math  -noprompt -run < matrixInversionAverage.m
# math  -noprompt -run < OptimizationTutorial_FrobeniusNorm_N21.m
# math  -noprompt -run < YangVectors.m
# math  -noprompt -run < MUBvectors.m
# math  -noprompt -run < onePieceOpt2.4CompProdCleanSlate1.5Pruned1.6.m
# math  -noprompt -run < onePieceOpt2.4CompProdCleanSlate1.5Pruned1.6.Parallel.m
# math  -noprompt -run < OptimizationTutorial_FrobeniusNorm_N7_AdaptiveStep.m
# math  -noprompt -run < FastCalculationYangPenalty.m

# matlab -nodesktop -nodisplay -nosplash -r "print_figure('ExponentialPlot','-dpng');exit"
# matlab_simple.m ParallelComputing.m
# matlab -nodisplay -nosplash <  JX_16QAM_v4.m
# matlab -nodesktop -nodisplay -nosplash -r "JX_16QAM_v4.m;exit"
# Create a temporary directory on scratch

mkdir -p $SCRATCH/$SLURM_JOB_ID

# Kick off matlab
# matlab -nodisplay < JX_16QAM_v4.m 
# tlab -nodisplay -nosplash <  test_parallel_program.m
# matlab -nodisplay -nosplash <  fact_run.m
# matlab -nodisplay -nosplash -r  "qsmf_simulation(5)"
matlab -nodisplay -nosplash < JX_v8_parallel_main.m

# Cleanup local work directory
rm -rf $SCRATCH/$SLURM_JOB_ID

echo "Ended batch processing at `date`."