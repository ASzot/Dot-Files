#!/bin/sh

# Clean up downloads folder.
find ~/Downloads/* -maxdepth 1 -mtime +1 -exec rm -rf {} \;

# rm -f ~/Downloads/BeFocused.csv
# Fetch the BeFocused data
# open -n /Users/andrewszot/Library/Mobile\ Documents/com\~apple\~Automator/Documents/export_befocused_csv.app

# Get daily PDFs
rm ~/me/daily_pdfs/*
cd ~/Downloads
/Users/andrewszot/miniconda3/bin/python ~/.dot-files/cron/get_daily.py

# Update the core PDFs
sh ~/me/math/analysis/generate_pdfs.sh
sh ~/me/research_analysis/generate_pdfs.sh

# Remove the auxiliary latex files.
for folderName in "daily_pdfs" "core_pdfs" "research" "research_analysis" "math_encyclopedia"
do
	rm ~/me/$folderName/*.aux
	rm ~/me/$folderName/*.out
	rm ~/me/$folderName/*.log
	rm ~/me/$folderName/*.fls
done

# Push wiki
cd ~/me && git add -A && git commit -m "Daily update" && git push

open ~/me/daily_pdfs/

