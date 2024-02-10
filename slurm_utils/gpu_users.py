"""
Usage: `python gpu_users.py PARTITION` where PARTITION is optional for only displaying usage for that partition.
"""
import os
import shlex
import subprocess
import sys
from collections import defaultdict
from dataclasses import dataclass
from io import StringIO

import pandas as pd


def main():
    output = (
        subprocess.Popen(
            shlex.split("/coc/testnvme/admin/tools/skynet-utilities/lab-quotas"),
            stdout=subprocess.PIPE,
        )
        .communicate()[0]
        .decode("UTF-8")
        .rstrip()
    )
    usage_df = pd.read_csv(StringIO(output), delim_whitespace=True)
    usage_df = usage_df.transpose()

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
    for lab, user_to_res in lab_to_user_to_res.items():
        print("-" * 10)
        print(lab)
        print(usage_df[lab].to_string(index=True))
        print("-" * 10)
        df = pd.DataFrame.from_dict(user_to_res).transpose()
        df.fillna(0.0, inplace=True)
        df = df.astype(int)
        print(df.to_string(index=True, line_width=120, col_space=5, justify="center"))
        print("\n" * 2)


if __name__ == "__main__":
    main()
