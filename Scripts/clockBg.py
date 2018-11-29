#!/usr/bin/env python
import zlib
from datetime import datetime
import os

def reduce(function, iterable, initializer=None):
    it = iter(iterable)
    if initializer is None:
        try:
            initializer = next(it)
        except StopIteration:
            raise TypeError('reduce() of empty sequence with no initial value')
    accum_value = initializer
    for x in it:
        accum_value = function(accum_value, x)
    return accum_value

def splitNumber (num):
    lst = []
    while num > 0:
        lst.append(num & 0xFF)
        num >>= 8
    return lst[::-1]

def add(x,y):
	return x+y

with open("/home/peter/Images/Backgrounds/testfit.png", "r+b") as f:
    header = f.read(8)
    if chr(header[1])+chr(header[2])+chr(header[3])=="PNG":
    	size = reduce(add,f.read(4))
    	chunk = reduce(add,map(chr,f.read(4)))
    	startOfColours=16
    	while chunk!="PLTE":
    		startOfColours+=size+12
    		f.read(size+4)
    		size = reduce(add,f.read(4))
    		chunk = reduce(add,map(chr,f.read(4)))
    	colours = list(f.read(size))
    	for i in range(len(colours))[0::3]:
    		colours[i]=191
    		colours[i+1]=171
    		colours[i+2]=146
    	time = datetime.now().time()
    	if time.hour/12>1:
    		colours[0]=20
    		colours[1]=0
    		colours[2]=100
    	else:
    		colours[0]=201
    		colours[1]=249
    		colours[2]=255
    	colours[(1+time.minute)*3]=64
    	colours[(1+time.minute)*3+1]=54
    	colours[(1+time.minute)*3+2]=40
    	colours[(61+(time.hour-1)%12)*3]=64
    	colours[(61+(time.hour-1)%12)*3+1]=54
    	colours[(61+(time.hour-1)%12)*3+2]=40
    	colourBytes = bytes(colours)
    	crc=splitNumber(zlib.crc32(bytes(chunk,'ascii')+colourBytes) & 0xFFFFFFFF)
    	if(len(crc)<4):
    		crc=[0]+crc
    	f.seek(startOfColours)
    	f.write(colourBytes)
    	f.write(bytes(crc))
    	f.flush()
os.system("feh --bg-tile /home/peter/Images/Backgrounds/testfit.png")