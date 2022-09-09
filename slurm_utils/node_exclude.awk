#!/bin/awk -f

BEGIN {
    FS="[ :]";
}
{
    if ($1 == "G>") {
        gpus_in_use[$5] += $4
        if ($4 == 8) {
            eight_gpu_job[$5] = 1
        }
    } else {
        cpu_load[$1] = $2
        gpus_in_use[$1] += 0
        total_gpus[$1] = $7
        eight_gpu_job[$1] = 0
    }
}
END {
    print_str = ""
    for (node in cpu_load) {
        avail_gpus = total_gpus[node] - gpus_in_use[node]
        # print_str = node ": PJL:"  PJL " avail_gpus:" avail_gpus "BLL-cpu_load:" BLL - cpu_load[node]
        # print(print_str);
        if ((PJL * avail_gpus > BLL - cpu_load[node]) && eight_gpu_job[node] == 0) {
            print(node);
            # print_str = print_str sprintf("%s,", node);
        }
        # print(node, cpu_load[node], gpus_in_use[node], cpu_load_per_gpu)
    }
}
