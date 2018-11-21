#!/bin/bash
export DISPLAY=:0
export XAUTHORITY=/home/peter/.Xauthority

xdotool search --class "^Skype$" set_window --urgency 1
