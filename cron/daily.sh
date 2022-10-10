#!/bin/sh

# Push wiki
cd ~/me && git add -A && git commit -m "Daily update" && git push

# Clean up downloads folder.
find ~/Downloads/* -maxdepth 1 -mtime +1 -exec rm -rf {} \;

rm -f ~/Downloads/BeFocused.csv
# Fetch the BeFocused data
open -n /Users/andrewszot/Library/Mobile\ Documents/com\~apple\~Automator/Documents/export_befocused_csv.app

rm ~/Downloads/daily/*

# Generate 
/Users/andrewszot/miniconda3/bin/python ~/.dot-files/cron/get_daily.py

# Remove the auxiliary latex files.
rm ~/Downloads/daily/*.aux
rm ~/Downloads/daily/*.out
rm ~/Downloads/daily/*.log

# Generate stats vis.
/Users/andrewszot/miniconda3/bin/python ~/.dot-files/cron/vis_stats.py

open ~/Downloads/daily
