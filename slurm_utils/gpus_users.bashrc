usage_by_lab() {
    {
        sacctmgr -nop show assoc format=account,user,grptres | grep -v 'root' | grep -v 'test-lab';
        squeue -O "UserName,StateCompact,QOS,tres-alloc:1000,Account,Partition" -h | tr -s " " | awk '$0="G> "$0' | grep gpu | sort;
    } | awk -f $1 -
}
usage_by_node() {
    { sinfo -o '%n %G %O %e %a %C %T' -S '-O'; squeue -o "G> %N %P [%t] %b %q %C" -h | grep "\[R\]"; } | awk -f $1 -
}

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
