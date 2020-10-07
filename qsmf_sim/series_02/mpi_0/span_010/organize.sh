#!/bin/bash
# script to make a kernel and move the image 
mkdir job_$1
mv qsmf_*.txt job_$1
cp qsmf_output* job_$1
mv qsmf_output* output/
