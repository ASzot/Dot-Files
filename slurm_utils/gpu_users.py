"""
Usage: `python gpu_users.py PARTITION` where PARTITION is optional for only displaying usage for that partition.
"""
import os
import re
import shlex
import subprocess
import sys
from collections import defaultdict
from dataclasses import dataclass
from io import StringIO

import pandas as pd


def custom_num_sort(item):
    """
    Sorts a list so elements that start with a number are not placed at the
    front.
    """

    if item.isdigit():
        return (1, int(item))
    else:
        # Extracting numeric and alphabetic parts
        numeric_part = re.search(r"\d+", item)
        alphabetic_part = re.search(r"[a-zA-Z]+", item)
        if numeric_part and alphabetic_part:
            # Combining the parts to form a tuple for sorting
            return (0, alphabetic_part.group(0), int(numeric_part.group(0)))
        elif numeric_part:
            return (0, "", int(numeric_part.group(0)))
        else:
            return (0, item)


def get_lab_caps() -> dict[str, dict[str, int]]:
    """
    Gets the
    """

    # Get caps per lab
    lab_caps = {}

    limits = (
        subprocess.run(["sacctmgr", "-n", "show", "qos", "-P"], stdout=subprocess.PIPE)
        .stdout.decode("utf-8")
        .splitlines()
    )
    for line in limits:
        if "lab" in line:
            fields = line.split("|")
            tres = fields[9].split(",")
            lab_caps[fields[0]] = {}
            for res in tres:
                caps = res.split("=")
                lab_caps[fields[0]][caps[0].replace("gres/gpu:", "")] = caps[1]
    return lab_caps


def get_lab_totals() -> dict[str, dict[str, int]]:
    # Running the specified command using subprocess
    command_output = subprocess.check_output(
        ["squeue", "-O", f"UserName:20,tres-alloc:100,State,Partition"], text=True
    )

    # Process the command output
    lines = command_output.strip().split("\n")[1:]  # Skip the header line

    lab_caps = get_lab_caps()
    all_gpus = ["a40", "rtx_6000", "a5000", "titan_x", "2080_ti", "cpu", "total_gpus"]
    lab_caps["overcap"] = {k: 0 for k in lab_caps[list(lab_caps.keys())[0]]}
    # add total_gpus to lab_caps
    for lab in lab_caps:
        lab_caps[lab]["total_gpus"] = sum(
            [int(lab_caps[lab][gpu]) for gpu in lab_caps[lab] if gpu != "cpu"]
        )
    lab_data = {}

    for line in lines:
        parts = line.split()
        if parts[2] == "RUNNING":
            # Find all occurrences of GPU types
            gpu_matches = re.findall(r"gres/gpu:(\w+)", line)
            lab = parts[-1]
            if lab not in lab_data:
                lab_data[lab] = {}
                lab_data[lab]["total_gpus"] = 0
                for gpu in gpu_matches:
                    lab_data[lab][gpu] = 0

            # Extract GPU information and update user data
            gpu_info = re.findall(r"gres/gpu=(\d+),gres/gpu:(\w+)=\d+", line)
            for count, gpu_type in gpu_info:
                count = int(count)
                if gpu_type not in lab_data[lab]:
                    lab_data[lab][gpu_type] = 0
                lab_data[lab][gpu_type] += count
                lab_data[lab]["total_gpus"] += count
    return lab_data, lab_caps


def main():
    lab_data, lab_caps = get_lab_totals()

    # partition -> user -> resource -> count
    lab_to_user_to_res = defaultdict(lambda: defaultdict(lambda: defaultdict(int)))

    if len(sys.argv) > 1:
        limit_partition = sys.argv[1]
    else:
        limit_partition = None
    command = f"squeue -O partition,jobid,username,tres-per-node,tres-per-job,numcpus,state --noheader"
    process = subprocess.Popen(shlex.split(command), stdout=subprocess.PIPE)
    (output, err) = process.communicate()
    exit_code = process.wait()
    output = output.decode("UTF-8").rstrip()

    for line in output.split("\n"):
        parts = [x for x in line.split(" ") if len(x) != 0]
        lab, jobid, user, gpu_per_node, gpu_per_job, cpus, status = parts

        if status != "RUNNING":
            use_user = f"{user}_{status}"
        else:
            use_user = user

        if gpu_per_node == "N/A":
            gpu = gpu_per_job
        else:
            gpu = gpu_per_node

        if gpu != "N/A":
            gpu_parts = gpu.split(":")
            gpu_type = gpu_parts[-2]
            gpu_count = int(gpu_parts[-1])
            lab_to_user_to_res[lab][use_user][gpu_type] += gpu_count
        lab_to_user_to_res[lab][use_user]["cpu"] += int(cpus)

    if limit_partition is not None:
        lab_to_user_to_res = {limit_partition: lab_to_user_to_res[limit_partition]}

    lab_behind_gpu = {
        lab: {
            # Max with 0 because they could be using overcap GPUs.
            res: max(int(lab_caps[lab][res]) - in_use_count, 0)
            for res, in_use_count in sublab_data.items()
        }
        for lab, sublab_data in lab_data.items()
    }
    overall_behind_gpu = defaultdict(int)
    for lab, sublab_data in lab_behind_gpu.items():
        for res, count in sublab_data.items():
            overall_behind_gpu[res] += count

    for lab, user_to_res in lab_to_user_to_res.items():
        print("-" * 10)
        print("[overcap]")
        overcap_disp_info = []
        for res in sorted(lab_data["overcap"].keys(), key=custom_num_sort):
            overcap_disp_info.append(
                f"{res}: {lab_data['overcap'][res]}/{overall_behind_gpu[res]}"
            )
        print(", ".join(overcap_disp_info))

        print(lab)
        lab_disp_info = []
        for res in sorted(lab_data[lab].keys(), key=custom_num_sort):
            lab_disp_info.append(f"{res}: {lab_data[lab][res]}/{lab_caps[lab][res]}")
        print(", ".join(lab_disp_info))
        print("-" * 10)

        df = pd.DataFrame.from_dict(user_to_res).transpose()
        df.fillna(0.0, inplace=True)
        df = df.astype(int)
        df = df.reindex(sorted(df.columns, key=custom_num_sort), axis=1)
        print(df.to_string(index=True, line_width=120, col_space=5, justify="center"))
        print("\n" * 2)


if __name__ == "__main__":
    main()
