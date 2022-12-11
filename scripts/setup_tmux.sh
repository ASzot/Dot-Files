#!/bin/sh

NAMES=("hablab" "rlt" "math" "me")
DIRS=("~/Documents/code/habitat-lab" "~/Documents/code/hablab_exp" "~/me" "~/me")
CONDA_ENVS=("hablab" "hablabexp" "" "")

for i in "${!NAMES[@]}"
do
	echo "${NAMES[i]}"
	tmux has-session -t "${NAMES[i]}" &> /dev/null

	if [ $? != 0 ] 
	then
		tmux new-session -s "${NAMES[i]}" -d
		tmux send-keys -t "${NAMES[i]}" "cd ${DIRS[i]} ; conda activate ${CONDA_ENVS[i]} ; nvim ." C-m 
		tmux split-window -t "${NAMES[i]}" -h
		tmux send-keys -t "${NAMES[i]}" "cd ${DIRS[i]} ; conda activate ${CONDA_ENVS[i]}" C-m 
		tmux split-window -t "${NAMES[i]}" -v -l "15%"
	fi
done

