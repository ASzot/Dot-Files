#!/bin/sh
for var in "$@"
do
    echo $var
    ssh -t aszot3@"$var".cc.gatech.edu '/usr/bin/nvidia-smi | head -50'
done
