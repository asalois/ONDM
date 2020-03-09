#!/bin/bash
grep "Elapsed time is"* *.out.txt -h | cut -d . -f 1 | cut -c 17-23 > run_time.txt 
cat run_time.txt | py --ji -l 'min(l)/3600, max(l)/3600, numpy.median(l)/3600, numpy.mean(l)/3600'
