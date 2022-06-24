#!/bin/sh

# Push wiki
cd ~/me && git add -A && git commit -m "Daily update" && git push

# Clean up downloads folder.
find ~/Downloads/* -maxdepth 1 -mtime +1 -exec rm -rf {} \;

rm ~/Downloads/daily/*

# Generate 
/Users/andrewszot/miniconda3/bin/python ~/me/get_daily.py

osascript -e 'display notification "Finished daily"'
