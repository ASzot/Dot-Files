#!/bin/sh

# Push wiki
cd ~/me && git add -A && git commit -m "Daily update" && git push

# Clean up downloads folder.
find ~/Downloads/* -maxdepth 1 -mtime +1 -exec rm -rf {} \;

rm ~/Downloads/daily/*

# Generate 
/Users/andrewszot/miniconda3/bin/python ~/.dot-files/cron/get_daily.py

# Remove the auxiliary latex files.
rm ~/Downloads/daily/*.aux
rm ~/Downloads/daily/*.out
rm ~/Downloads/daily/*.log

open ~/Downloads/daily
