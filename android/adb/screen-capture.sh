#!/usr/bin/env bash

adb shell "while true; do screenrecord --output-format=h264 -; done" | ffplay -framerate 60 -probesize 32 -sync video -
