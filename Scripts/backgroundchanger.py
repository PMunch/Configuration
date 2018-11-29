#!/usr/bin/env python
import _thread
import os
import time
import zlib
from datetime import datetime
import i3ipc
import struct

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


def split_number(num):
    lst = []
    while num > 0:
        lst.append(num & 0xFF)
        num >>= 8
    return lst[::-1]


def add(x, y):
    return x + y


class IndexedPNG:
    def __init__(self, filename):
        self.__filename__ = filename
        self.__open_png__ = None

    def __enter__(self):
        class OpenPNG:
            def __init__(self, fname):
                self.f = open(fname, "r+b")
                f = self.f
                header = f.read(8)
                if chr(header[1]) + chr(header[2]) + chr(header[3]) == "PNG":
                    sb = f.read(4)
                    size, = struct.unpack('>I', sb)  # reduce(add, f.read(4))
                    chunk = reduce(add, map(chr, f.read(4)))
                    start_of_colours = 16
                    while chunk != "PLTE":
                        start_of_colours += size + 12
                        f.read(size + 4)
                        size, = struct.unpack('>I', f.read(4))  # reduce(add, f.read(4))
                        chunk = reduce(add, map(chr, f.read(4)))
                    self.start_of_colours = start_of_colours
                    self.colours = list(f.read(size))

            def set_colours(self, new_colours):
                if not self.f.closed:
                    colour_bytes = bytes(new_colours)
                    crc = split_number(zlib.crc32(bytes("PLTE", 'ascii') + colour_bytes) & 0xFFFFFFFF)
                    if len(crc) < 4:
                        crc = [0] * (4 - len(crc)) + crc
                    self.f.seek(self.start_of_colours)
                    self.f.write(colour_bytes)
                    self.f.write(bytes(crc))
                    self.f.flush()

        self.__open_png__ = OpenPNG(self.__filename__)
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        if not self.__open_png__.f.closed:
            self.__open_png__.f.close()

    @property
    def colours(self):
        if self.__open_png__ is not None:
            return self.__open_png__.colours

    @colours.setter
    def colours(self, new_colours):
        if self.__open_png__ is not None:
            self.__open_png__.set_colours(new_colours)


background = "/home/peter/Images/Backgrounds/gauge.png"


def on_workspace_focus(i3Connection, e):
    with IndexedPNG(background) as png:
        colours = png.colours
        for i in range(219, 245, 3):
            colours[i] = 57
            colours[i + 1] = 57
            colours[i + 2] = 57
        focused = int(e.current.name)
        if focused != 10:
            colours[216 + focused * 3] = 255
            colours[216 + focused * 3 + 1] = 255
            colours[216 + focused * 3 + 2] = 255
        png.colours = colours
        os.system("feh --bg-tile " + background)


def setup_i3_connection(i3_connection):
    # Wait for i3 to start when a reset occurs
    if i3_connection is not None:
        time.sleep(1)
    global i3
    i3 = i3ipc.Connection()
    i3.on('workspace::focus', on_workspace_focus)
    i3.on('ipc-shutdown', setup_i3_connection)
    _thread.start_new_thread(i3.main, ())

# Create an i3 connection and set up a listener
# i3 = i3ipc.Connection()
# i3.on('workspace::focus', on_workspace_focus)
# i3.on('ipc-shutdown', setup_i3_connection)
# _thread.start_new_thread(i3.main, ())
setup_i3_connection(None)
with IndexedPNG(background) as png:
        colours = png.colours
        for i in range(219, 245, 3):
            colours[i] = 57
            colours[i + 1] = 57
            colours[i + 2] = 57
        focused = int(i3.get_tree().find_focused().workspace().name)
        if focused != 10:
            colours[216 + focused * 3] = 134
            colours[216 + focused * 3 + 1] = 164
            colours[216 + focused * 3 + 2] = 219
        png.colours = colours
        os.system("feh --bg-tile " + background)

while 1:
    now = datetime.now().time()
    with IndexedPNG(background) as png:
        colours = png.colours
        for i in range(0, 219, 3):
            colours[i] = 57
            colours[i + 1] = 57
            colours[i + 2] = 57
        if now.hour / 12 > 1:
            colours[0] = 20
            colours[1] = 0
            colours[2] = 100
        else:
            colours[0] = 201
            colours[1] = 249
            colours[2] = 255
        colours[(1 + now.minute) * 3] = 134
        colours[(1 + now.minute) * 3 + 1] = 164
        colours[(1 + now.minute) * 3 + 2] = 219
        colours[(61 + (now.hour - 1) % 12) * 3] = 134
        colours[(61 + (now.hour - 1) % 12) * 3 + 1] = 164
        colours[(61 + (now.hour - 1) % 12) * 3 + 2] = 219
        #hwmons = ("/sys/devices/platform/coretemp.0/hwmon/hwmon1/temp2_input",
        #  "/sys/devices/platform/coretemp.0/hwmon/hwmon0/temp2_input")
        #for i in range(246, 320, 3):
        #    colours[i] = 191
        #    colours[i + 1] = 171
        #    colours[i + 2] = 146
        #with open(hwmons[os.path.isfile(hwmons[1])], 'r') as f:
        #    temp = int(int(f.read())/1000)
        #min = 35
        #max = 60
        #temp = min if temp < min else temp
        #temp = max if temp > max else temp
        #for i in range(temp-min):
        #    colours[246+i*3] = 144
        #    colours[246+i*3+1] = 0
        #    colours[246+i*3+2] = 0
        # colours[246] = int(255*(temp - min)/(max - min))
        # colours[247] = int(255*(temp - min)/(max - min))
        # colours[248] = int(255*(temp - min)/(max - min))
        png.colours = colours
        os.system("feh --bg-tile " + background)

    #print(i3.get_outputs())
    time.sleep(61 - now.second)
    #time.sleep(3)
