import os
import shlex
from collections import defaultdict
from subprocess import PIPE, Popen

import yaml
from utils import send_message

process = Popen(shlex.split("squeue -p long -n bash"), stdout=PIPE)
(output, err) = process.communicate()
exit_code = process.wait()
output = output.decode("UTF-8").rstrip()

matching = output.split("\n")[1:]

REPORT_CHANNEL = "skynet-monitoring"
with open("/coc/testnvme/aszot3/.cvmlp_info.yaml", "r") as f:
    settings = yaml.safe_load(f)
settings["CHANNEL"] = REPORT_CHANNEL

user_job_counts = defaultdict(lambda: 0)
for match in matching:
    fields = [x for x in match.split(" ") if x.strip() != ""]
    job_id = fields[0]
    user_id = fields[3]
    user_job_counts[user_id] += 1
    result = os.system(f"sudo scancel {job_id}")
out_s = "Bad Jobs"
for user, count in user_job_counts.items():
    out_s += f"\n{user}: {count}"
send_message(settings, out_s)
