#!/bin/bash
# get and print inputs
grep "CANCELLED" *err.txt | cut -d . -f 1 > failed_files.txt