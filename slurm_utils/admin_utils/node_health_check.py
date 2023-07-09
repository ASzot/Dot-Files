import os
import shlex
from collections import defaultdict
from subprocess import PIPE, Popen

import yaml
from utils import send_message

process = Popen(
    shlex.split("sinfo -R"),
    stdout=PIPE,
)
(output, err) = process.communicate()
output = output.decode("UTF-8").rstrip()

matching = output.split("\n")[1:]

notresp_nodes = []
other_nodes = []
bad_nodes = []
for match in matching:
    fields = [x for x in match.split("  ") if x.strip() != ""]
    status = fields[0]
    node = fields[-1].split(" ")[-1]

    if status in ["Epilog error", "Prolog error"]:
        bad_nodes.append(node)
    elif status in ["Not responding"]:
        notresp_nodes.append(node)
    else:
        other_nodes.append(node)

out_s = f"{len(bad_nodes)} need reboot. {len(notresp_nodes)} not responding. {len(other_nodes)} down for other reasons. ADMIN MUST RUN:"
nodes_str = " ".join(bad_nodes)
out_s += "\n"
out_s += f"\n`sh ~/.dot-files/slurm_utils/slurm_restart_batch.sh {nodes_str}`"
out_s += "\n"
out_s += f"\n`sh ~/.dot-files/slurm_utils/slurm_check_batch.sh {nodes_str}`"

REPORT_CHANNEL = "skynet-monitoring"
with open("/coc/testnvme/aszot3/.cvmlp_info.yaml", "r") as f:
    settings = yaml.safe_load(f)
settings["CHANNEL"] = REPORT_CHANNEL


print(out_s)
send_message(settings, out_s)
