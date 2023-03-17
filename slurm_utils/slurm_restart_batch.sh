#!/bin/sh
for var in "$@"
do
    echo $var
    ssh -t aszot3@"$var".cc.gatech.edu 'sudo shutdown --reboot 0 && exit'
done
