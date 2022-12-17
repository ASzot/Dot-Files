#!/bin/sh
# Usage: setup_tmux.sh session_name start_path conda_env
# Conda env can be "" for no conda env.

tmux has-session -t "$1" &> /dev/null

if [ $? != 0 ] 
then
	tmux new-session -s "$1" -d
	tmux send-keys -t "$1" "cd $2 ; conda activate $3 ; nvim ." C-m 
	tmux split-window -t "$1" -h
	tmux send-keys -t "$1" "cd $2 ; conda activate $3" C-m 
	tmux split-window -t "$1" -v -l "15%"
fi

