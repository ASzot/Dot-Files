#!/bin/sh

# Clean up downloads folder.
find ~/Downloads/* -maxdepth 1 -mtime +1 -exec rm -rf {} \;

cd ~/me && git add -A && git commit -m "Daily update" && git push
cd ~/notes && git add -A && git commit -m "Daily update" && git push

