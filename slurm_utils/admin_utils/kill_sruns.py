"""
WIP: Not working yet to identify which jobs are actually stragglers.
"""

import os
import shlex
from collections import defaultdict
from subprocess import PIPE, Popen

process = Popen(
    shlex.split("ps ax o user:16,pid,cmd"),
    stdout=PIPE,
)
(output, err) = process.communicate()
output = output.decode("UTF-8").rstrip()

matching = output.split("\n")[1:]


num_jobs = defaultdict(lambda: 0)
for proc in matching:
    fields = [x for x in proc.split(" ") if x.strip() != ""]
    cmd = fields[2]
    if "srun" not in cmd:
        continue
    user = fields[0]
    pid = fields[1]
    num_jobs[user] += 1

squeue_out = (
    Popen(shlex.split("squeue --Format=username,jobid,batchflag"), stdout=PIPE)
    .communicate()[0]
    .decode("UTF-8")
    .rstrip()
    .split("\n")[1:]
)
num_squeue_jobs = defaultdict(lambda: 0)
for proc in squeue_out:
    fields = [x for x in proc.split(" ") if x.strip() != ""]
    user = fields[0]
    is_batch = fields[2]
    if "0" not in is_batch:
        continue
    num_squeue_jobs[user] += 1

for user in num_jobs.keys():
    if num_squeue_jobs[user] < num_jobs[user]:
        # The user has abandoned processes
        print(f"BAD {user}: {num_jobs[user]}/{num_squeue_jobs[user]}")
    else:
        print(f"FINE {user}: {num_jobs[user]}/{num_squeue_jobs[user]}")
