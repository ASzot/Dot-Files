#!/bin/awk -f
@include "mycolors.awk"

BEGIN {
    FS="[ :|=,]";
    printf("| %14s |","Username");
    printf(" %3s | %3s| %3s|", "N-R", "N-PD", "N-CG");
    printf(" %3s | %3s| %3s|", "O-R", "O-PD", "O-CG");
    printf(" %3s | %3s | %3s |", "R", "PD", "CG");
    printf("\n");

    printf("| %14s |","--------------");
    printf(" %3s + %3s + %3s |", "---", "---", "---");
    printf(" %3s + %3s + %3s |", "---", "---", "---");
    printf(" %3s + %3s + %3s |", "---", "---", "---");
    printf("\n");

    printf("| %-68s |\n","  'N': normal, 'O': overcap, none: total");
    # printf("| %-68s |\n","  'R': running, 'PD': pending, 'CG': interrupted");

    printf("| %14s |","--------------");
    printf(" %3s + %3s + %3s |", "---", "---", "---");
    printf(" %3s + %3s + %3s |", "---", "---", "---");
    printf(" %3s + %3s + %3s |", "---", "---", "---");
    printf("\n");
}
{
    if ($1 == "G>") {
        # GPU Counts
        gpu_counts[$2][$3]+=$6;
        gpu_counts[$2][$3,$4]+=$6;

        gpu_counts[$2]["R"]+=0;
        gpu_counts[$2]["PD"]+=0;
        gpu_counts[$2]["CG"]+=0;

        gpu_counts[$2]["R","normal"]+=0;
        gpu_counts[$2]["PD","normal"]+=0;
        gpu_counts[$2]["CG","normal"]+=0;
        gpu_counts[$2]["R","overcap"]+=0;
        gpu_counts[$2]["PD","overcap"]+=0;
        gpu_counts[$2]["CG","overcap"]+=0;

        # CPU counts
        cpu_counts[$2][$3]+=$7;
        cpu_counts[$2][$3,$4]+=$7;

        cpu_counts[$2]["R"]+=0;
        cpu_counts[$2]["PD"]+=0;
        cpu_counts[$2]["CG"]+=0;

        cpu_counts[$2]["R","normal"]+=0;
        cpu_counts[$2]["PD","normal"]+=0;
        cpu_counts[$2]["CG","normal"]+=0;
        cpu_counts[$2]["R","overcap"]+=0;
        cpu_counts[$2]["PD","overcap"]+=0;
        cpu_counts[$2]["CG","overcap"]+=0;

        labs_to_gpus_used[user_to_lab[$2]][$3]+=$6;
        labs_to_cpus_used[user_to_lab[$2]][$3]+=$7;

        lab_gpu_totals[user_to_lab[$2]][$3]+=$6;
        lab_cpu_totals[user_to_lab[$2]][$3]+=$7;

        lab_gpu_totals[user_to_lab[$2]][$3,$4]+=$6;
        lab_cpu_totals[user_to_lab[$2]][$3,$4]+=$7;

    } else {
        if ($5 == "gres/gpu") {
            labs_to_gpus[$1] += $6;
            labs_to_cpus[$1] += $4;
        } else {
            if ($1 != "overcap") {
                user_to_lab[$2]=$1;
            }
        }
    }
}
END {
    for (lab in labs_to_gpus) {
        if (lab == "guest-lab") {
            continue;
        }
        print_str = sprintf(\
            "[ %d / %d / %d (Run/Sched/Total) GPUS]",
            labs_to_gpus_used[lab]["R"],
            labs_to_gpus_used[lab]["PD"],
            labs_to_gpus[lab])
        printf("| %14s = %-51s |\n", lab, print_str);
        for (name in gpu_counts){
            if (user_to_lab[name] == lab) {
                printf("| %14s |",name);
                # printf(" %3d |",gpu_counts[name]["R","normal"]);
                # printf(" %3d |",gpu_counts[name]["PD","normal"]);
                # printf(" %3d |",gpu_counts[name]["CG","normal"]);
                #
                # printf(" %3d |",gpu_counts[name]["R","overcap"]);
                # printf(" %3d |",gpu_counts[name]["PD","overcap"]);
                # printf(" %3d |",gpu_counts[name]["CG","overcap"]);
                #
                # printf(" %3d |",gpu_counts[name]["R"]);
                # printf(" %3d |",gpu_counts[name]["PD"]);
                # printf(" %3d |",gpu_counts[name]["CG"]);

                printf(" %s |",colour_int(gpu_counts[name]["R","normal"]));
                printf(" %s |",colour_int(gpu_counts[name]["PD","normal"]));
                printf(" %s |",colour_int(gpu_counts[name]["CG","normal"]));

                printf(" %s |",colour_int(gpu_counts[name]["R","overcap"]));
                printf(" %s |",colour_int(gpu_counts[name]["PD","overcap"]));
                printf(" %s |",colour_int(gpu_counts[name]["CG","overcap"]));

                printf(" %s |",colour_int(gpu_counts[name]["R"]));
                printf(" %s |",colour_int(gpu_counts[name]["PD"]));
                printf(" %s |",colour_int(gpu_counts[name]["CG"]));

                printf("\n");
            }
        }
        printf("| %14s |","");
        printf(" %3s + %3s + %3s |", "---", "---", "---");
        printf(" %3s + %3s + %3s |", "---", "---", "---");
        printf(" %3s + %3s + %3s |", "---", "---", "---");
        printf("\n");

        printf("| %14s :","totals");
        printf(" %3d |",lab_gpu_totals[lab]["R","normal"]);
        printf(" %3d |",lab_gpu_totals[lab]["PD","normal"]);
        printf(" %3d |",lab_gpu_totals[lab]["CG","normal"]);

        printf(" %3d |",lab_gpu_totals[lab]["R","overcap"]);
        printf(" %3d |",lab_gpu_totals[lab]["PD","overcap"]);
        printf(" %3d |",lab_gpu_totals[lab]["CG","overcap"]);

        printf(" %3d |",lab_gpu_totals[lab]["R"]);
        printf(" %3d |",lab_gpu_totals[lab]["PD"]);
        printf(" %3d |",lab_gpu_totals[lab]["CG"]);

        # Colorized:
        # printf(" %s |",colour_int(lab_gpu_totals[lab]["R","normal"]));
        # printf(" %s |",colour_int(lab_gpu_totals[lab]["PD","normal"]));
        # printf(" %s |",colour_int(lab_gpu_totals[lab]["CG","normal"]));
        #
        # printf(" %s |",colour_int(lab_gpu_totals[lab]["R","overcap"]));
        # printf(" %s |",colour_int(lab_gpu_totals[lab]["PD","overcap"]));
        # printf(" %s |",colour_int(lab_gpu_totals[lab]["CG","overcap"]));
        #
        # printf(" %s |",colour_int(lab_gpu_totals[lab]["R"]));
        # printf(" %s |",colour_int(lab_gpu_totals[lab]["PD"]));
        # printf(" %s |",colour_int(lab_gpu_totals[lab]["CG"]));
        printf("\n");

        printf("| %14s |","--------------");
        printf(" %3s + %3s + %3s |", "---", "---", "---");
        printf(" %3s + %3s + %3s |", "---", "---", "---");
        printf(" %3s + %3s + %3s |", "---", "---", "---");
        printf("\n");
    }
}
