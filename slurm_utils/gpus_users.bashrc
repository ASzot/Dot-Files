
gpus_users() {
    if [ $# -eq 1 ]; then
        if [[ $1 == "-q" ]]; then
            usage_by_lab ~/.dot-files/slurm_utils/lab_usage_qos.awk
        elif [[ $1 == "-v" ]]; then
            usage_by_lab ~/.dot-files/slurm_utils/lab_usage_verbose.awk
        fi
    else
        usage_by_lab ~/.dot-files/slurm_utils/lab_usage.awk
    fi
}

node_usage() {
    if [ $# -eq 1 ]; then
        if [[ $1 == "-q" ]]; then
            usage_by_node ~/.dot-files/slurm_utils/node_usage.awk
        elif [[ $1 == "-v" ]]; then
            usage_by_node ~/.dot-files/slurm_utils/node_usage.awk
        fi
    else
        usage_by_node ~/.dot-files/slurm_utils/node_usage.awk
    fi
}
