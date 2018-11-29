#!/usr/bin/env python
import fileinput

with open("/home/peter/Projects/i3 Colour changer/testfile","w") as f:
    for line in fileinput.input():
        f.write(line)