#!/bin/sh

NAMES=("hablab" "rlt" "me")
DIRS=("~/Documents/code/habitat-lab" "~/Documents/code/hablab_exp" "~/me")
CONDA_ENVS=("hablab" "hablabexp" "")

for i in "${!NAMES[@]}"
do
	MYDIR="$(dirname "$(realpath "$0")")"
	sh $MYDIR/create_tmux.sh ${NAMES[i]} ${DIRS[i]} ${CONDA_ENVS[i]}
done

