#!/bin/awk -f
@include "mycolors.awk"

function print_row_separator()
{
    printf("| %14s |","--------------");
    # printf(" %3s + %3s + %3s |", "---", "---", "---");
    printf(" %9s + %3s + %3s |", "---------", "---", "---");
    printf("\n");
}

BEGIN {
    FS="[ :|=,]";
    print_row_separator()

    printf("| %14s |","Username");
    green_G = colour_str_custom("G", colour("Green"), 1);
    blue_C = colour_str_custom("C", colour("Blue"), 1);
    printf(" %27s | %3s | %3s |", sprintf("R (%s/%s)", blue_C, green_G), "PD", "CG");
    printf("\n");

    print_row_separator()
}
{
    if ($1 == "G>") {
        gpu_counts[$2][$3]+=$6;
        gpu_counts[$2][$3,$4]+=$6;

        gpu_counts[$2]["R"]+=0;
        gpu_counts[$2]["PD"]+=0;
        gpu_counts[$2]["CG"]+=0;

        cpu_counts[$2][$3]+=$7;
        cpu_counts[$2][$3,$4]+=$7;

        cpu_counts[$2]["R"]+=0;
        cpu_counts[$2]["PD"]+=0;
        cpu_counts[$2]["CG"]+=0;

        labs_to_gpus_used[user_to_lab[$2]][$3]+=$6;
        labs_to_cpus_used[user_to_lab[$2]][$3]+=$7;

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
            "[ %d/%d/%d ]",
            labs_to_gpus_used[lab]["R"],
            labs_to_gpus_used[lab]["PD"],
            labs_to_gpus[lab])
        printf("| %14s | %-21s |\n", lab, print_str);
        print_row_separator()
        for (name in gpu_counts){
            if (user_to_lab[name] == lab) {
                cpu_per_gpu_use_str = "-"
                if (gpu_counts[name]["R"] > 0){
                    cpu_per_gpu_use = (1.0*cpu_counts[name]["R"]) / gpu_counts[name]["R"]
                    # cpu_per_gpu_use_str = sprintf("%.1f", cpu_per_gpu_use)
                    if (cpu_per_gpu_use >= 10.0) {
                        cpu_per_gpu_use_str = sprintf("%d", cpu_per_gpu_use)
                    } else {
                        cpu_per_gpu_use_str = sprintf("%.1f", cpu_per_gpu_use)
                    }

                    run_str = sprintf(\
                        " %s (%s) |",\
                        colour_int(gpu_counts[name]["R"]),\
                        colour_str_custom(cpu_per_gpu_use_str, colour("Blue"), 3)\
                    )
                } else {
                    run_str = sprintf(" %9s |", colour_int(gpu_counts[name]["R"]))
                }

                printf("| %14s |",name);

                # printf(" %3d |",gpu_counts[name]["R"]);
                # printf(" %3d |",gpu_counts[name]["PD"]);
                # printf(" %3d |",gpu_counts[name]["CG"]);

                # Colorized
                # printf(\
                #     " %s (%s) |",\
                #     colour_int(gpu_counts[name]["R"]),\
                #     colour_str_custom(cpu_per_gpu_use_str, colour("Blue"), 3)\
                # );
                printf(run_str);
                printf(" %s |", colour_int(gpu_counts[name]["PD"]));
                printf(" %s |", colour_int(gpu_counts[name]["CG"]));


                # printf(" %s |", colour_int_blue(cpu_counts[name]["R"]));
                # printf(" %s |", colour_str_custom(cpu_per_gpu_use_str, colour("Blue"), 3));

                printf("\n");
            }
        }
        print_row_separator()
    }
}
