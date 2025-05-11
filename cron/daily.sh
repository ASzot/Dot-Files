#!/bin/sh

cd /Users/andrewszot/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/notes-synced && git add -A && git commit -m "Daily update" && git push
python ~/.dot-files/cron/daily_obsidian.py

