#!/bin/bash
# find the files that got canceled then print them to failed_files
grep "CANCELLED" *err.txt | cut -d . -f 1 > failed_files.txt
