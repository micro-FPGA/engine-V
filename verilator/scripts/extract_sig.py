#!/usr/bin/env python3

import fileinput

in_sig = 0

for line in fileinput.input():
    if line.startswith("[TESTBENCH_END]"):
        in_sig = 0
    if in_sig:
        print(line.strip())	
    if line.startswith("[TESTBENCH_BEGIN]"):
        in_sig = 1

