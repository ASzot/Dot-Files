#!/bin/awk -f
@include "mycolors.awk"

BEGIN {
    FS="[ :|=,]";
    printf("| %14s |","Username");
    printf(" %3s | %3s | %3s |", "N-R", "O-R", "R");
    printf("\n");

    printf("| %14s |","--------------");
    printf(" %3s + %3s + %3s |", "---", "---", "---");
    printf("\n");
}
{
    if ($1 == "G>") {
        gpu_counts[$2][$3]+=$6;
        gpu_counts[$2][$3,$4]+=$6;

        gpu_counts[$2]["R"]+=0;
        gpu_counts[$2]["R","normal"]+=0;
        gpu_counts[$2]["R","overcap"]+=0;

        labs_to_gpus_used[user_to_lab[$2]][$3]+=$6;
        lab_totals[user_to_lab[$2]][$3]+=$6;
        lab_totals[user_to_lab[$2]][$3,$4]+=$6;

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
        print_str = sprintf("[ %d/%d/%d ]", labs_to_gpus_used[lab]["R"], labs_to_gpus_used[lab]["PD"], labs_to_gpus[lab])
        printf("| %14s | %-15s |\n", lab, print_str);
        for (name in gpu_counts){
            if (user_to_lab[name] == lab) {
                printf("| %14s |",name);

                # printf(" %3d |",gpu_counts[name]["R","normal"]);
                # printf(" %3d |",gpu_counts[name]["R","overcap"]);
                # printf(" %3d |",gpu_counts[name]["R"]);

                # Colorized
                printf(" %s |",colour_int(gpu_counts[name]["R","normal"]));
                printf(" %s |",colour_int(gpu_counts[name]["R","overcap"]));
                printf(" %s |",colour_int(gpu_counts[name]["R"]));

                printf("\n");
            }
        }
        printf("| %14s |","");
        printf(" %3s + %3s + %3s |", "---", "---", "---");
        printf("\n");

        printf("| %14s :","totals");
        printf(" %3d |",lab_totals[lab]["R","normal"]);
        printf(" %3d |",lab_totals[lab]["R","overcap"]);
        printf(" %3d |",lab_totals[lab]["R"]);
        printf("\n");

        printf("| %14s |","--------------");
        printf(" %3s + %3s + %3s |", "---", "---", "---");
        printf("\n");
    }
}
