#!/bin/awk -f
@include "mycolors.awk"

BEGIN {
    FS="[ :|=*]";
    # printf("| %14s |","Username");
    # printf(" %3s | %3s | %3s |", "R", "PD", "CG");
    # printf("\n");
    #
    # printf("| %14s |","--------------");
    # printf(" %3s + %3s + %3s |", "---", "---", "---");
    # printf("\n");

    # # hack to use attributes for just "None"
    # noc = colour("None");
    # red = colour("Red");
    # cln = noc;

    i = 0;

    # Fixed parameters
    CPU_PER_JOB_LIMIT = 14;
    CPU_PER_GPU_USE_LIMIT = 20;
    CPU_THREADS_PER_NODE = 56;
}
{
    if ($1 == "G>") {
        # counts[$2][$3]+=$NF;
        # counts[$2][$3,$4]+=$NF;
        #
        # counts[$2]["R"]+=0;
        # counts[$2]["PD"]+=0;
        # counts[$2]["CG"]+=0;
        #
        # labs_to_gpus_used[user_to_lab[$2]][$3]+=$NF;
        if ($5 == "(null)" || $6 == 0) {
            cpu_jobs[$2] += 1
        } else {
            gpus_used[$2] += $6
            gpus_used[$2,$7] += $6
            gpu_jobs[$2] += 1
        }
        total_jobs[$2] += 1
    } else {
        # if ($3 == "gres/gpu") {
        #     labs_to_gpus[$1] += $4;
        # } else {
        #     user_to_lab[$2] = $1;
        # }
        if ($1 != "HOSTNAMES"){
            # print(i, $1)
            node_names[i++] = $1
            total_i = i
            total_gpus[$1] = $3
            cpu_load[$1] = $4
            free_mem[$1] = $5
            state[$1] = $8
        }
    }
}
END {
    printf("| %11s |","-----------");
    printf(" %s + %s + %s + %s + %s + %s |",
        "---", "------------", "---", "---", "---", "----------");
    printf("\n");

    printf("| %11s |","Node");
    printf(" %3s | %8s | %3s | %3s | %3s | %10s |",
        "G/T", "GJ + CJ =  T", "CPU", "/TJ", "/GU", "state");
    printf("\n");


    printf("| %11s |","-----------");
    printf(" %s + %s + %s + %s + %s + %s |",
        "---", "------------", "---", "---", "---", "----------");
    printf("\n");
    for (i=0; i<total_i; i++) {
        node = node_names[i];
        # print(i, node)
        if (state[node] == "down" || state[node] == "drained") {
            # printf("| %s is down!\n",node)
            continue
        } else {
            cpu_per_job_str = "N/A"
            cpu_per_gpu_use_str = "N/A"
            clr = noc; cl1 = noc; cl2 = noc; cl3 = noc;
            if (state[node] == "drained" || state[node] == "draining" ) {
                cls = colour("Yellow");
                clr = cls;
            } else if (state[node] == "idle") {
                cls = colour("Green");
                clr = cls;
            } else {
                cls = cln;
            }
            if (total_jobs[node] > 0){
                cpu_per_job = cpu_load[node] / total_jobs[node]
                cpu_per_job_str = sprintf("%d", cpu_per_job)
                if (cpu_per_job > CPU_PER_JOB_LIMIT && cpu_load[node] > CPU_THREADS_PER_NODE) {
                    clr = red;
                    cl2 = red;
                    # printf("> %s <\n", cpu_per_job_str)
                }
            }
            if (gpus_used[node] > 0){
                cpu_per_gpu_use = cpu_load[node] / gpus_used[node]
                cpu_per_gpu_use_str = sprintf("%d", cpu_per_gpu_use)
                if (cpu_per_gpu_use > CPU_PER_GPU_USE_LIMIT && cpu_load[node] > CPU_THREADS_PER_NODE) {
                    clr = red;
                    cl3 = red;
                    # printf("> %s <\n", cpu_per_job_str)
                }
            }
            if (cpu_load[node] > 100) {
                clr = red;
                cl1 = red;
            }
            printf("| %s%11s%s |",clr, node, cln)
            printf(\
                " %s/%d |",
                # gpus_used[node],
                colour_int_custom(gpus_used[node],colour("Magenta"),0),
                total_gpus[node]\
            )
            # _str = sprintf(\
            #     "%s+%d=%d",
            #     # gpu_jobs[node],
            #     colour_int_custom(gpu_jobs[node],colour("Magenta")),
            #     cpu_jobs[node],
            #     total_jobs[node])
            # # printf(" %8s |", _str)
            # printf(" %16s |", _str)
            printf(" %s + %s = %2d |",
                colour_int_custom(gpu_jobs[node],colour("Magenta"),2),
                colour_int_custom(cpu_jobs[node],colour("Blue"),2),
                total_jobs[node])

            printf(" %s%3d%s |", cl1, cpu_load[node], cln);
            printf(" %s%3s%s |", cl2, cpu_per_job_str, cln);
            printf(" %s%3s%s |", cl3, cpu_per_gpu_use_str, cln);
            # print ;
            printf(" %s%10s%s |", cls, state[node], cln);
            printf("\n")
        }
        # print_str = sprintf("[ %d/%d/%d ]", labs_to_gpus_used[lab]["R"], labs_to_gpus_used[lab]["PD"], labs_to_gpus[lab])
        # printf("| %14s | %-15s |\n", lab, print_str);
        # for (name in counts){
        #     if (user_to_lab[name] == lab) {
        #         printf("| %14s |",name);
        #         printf(" %3d |",counts[name]["R"]);
        #         printf(" %3d |",counts[name]["PD"]);
        #         printf(" %3d |",counts[name]["CG"]);
        #         printf("\n");
        #     }
        # }
        # printf("| %14s |","--------------");
        # printf(" %3s + %3s + %3s |", "---", "---", "---");
        # printf("\n");
    }
    printf("| %11s |","-----------");
    printf(" %s + %s + %s + %s + %s + %s |",
        "---", "------------", "---", "---", "---", "----------");
    printf("\n");

    printf("| %11s%-52s |\n", "legend", "")
    printf("| %11s%-52s |\n", "G/T:", " GPUs in use / total GPUs")
    printf("| %11s%-52s |\n", "GJ+CJ=T:", " GPU Jobs + CPU Jobs running = total jobs")
    printf("| %11s%-52s |\n", "CPU:", " CPU Load")
    printf("| %11s%-52s |\n", "/TJ:", " CPU Load / Total jobs running")
    printf("| %11s%-52s |\n", "/GU:", " CPU Load / GPU in use")
    # printf("| %59s |\n", "")

    printf("| %11s |","-----------");
    printf(" %s + %s + %s + %s + %s + %s |",
        "---", "------------", "---", "---", "---", "----------");
    printf("\n");

    printf("| %11s | %s |\n","-----------", "---------");
    for (node in state) {
        if (state[node] == "down" || state[node] == "drained") {
            printf("| %11s | %s %s%8s%s |\n",
                node, "", colour("Yellow"), state[node], cln)
        }
    }
    printf("| %11s | %s |\n","-----------", "---------");
}
