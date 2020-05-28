# a file to find all the numbers not found in a list
import sys
import pandas
in_nums = pandas.read_csv('good_jobs.csv')

# input arguments from cli
in_x = int(sys.argv[1]) + 1
in_start = int(sys.argv[2])
num_grab = int(sys.argv[3])
sleep_time = int(sys.argv[4])
num_same_time = int(sys.argv[5])


j = 0
num_list = []
over = False
print_2 = False

# print list function to print lists and append which file needs to be run
def print_list(i):
    print("sbatch --array=", end = '')
    print(*num_list, sep = ",", end = '')
    if i > 1000 + num_grab or print_2:
        print(" qsmf_2.slurm")
    else:
        print("%" + str(num_same_time) + " qsmf.slurm")
    print("sleep", str(sleep_time))

# beggining of bash script
print("#!/bin/bash")
print("# to relaunch jobs")
for i in range(in_start, in_x):
    if not (i in in_nums.values):
        if i > 1000 and i <= (1000 + num_grab) and over == False:
            over = True
            j = num_grab
            print_list(i)
            num_list = []
            print_2 = True
        if i > 1000:
            num_list.append(i - 1000)
        else:
            num_list.append(i)
        j += 1
    if j > num_grab or (i == (in_x - 1) and num_list):
        print_list(i)
        j = 0
        num_list = []
print("echo Done")
