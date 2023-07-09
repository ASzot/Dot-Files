"""
# File should look something like:
SLACK_ENDPOINT: https://hooks.slack.com/services/UUID
THRESHOLD: 90
CHANNEL: "#channel"
USER: "slack_user"
LAB: "lab_name"
STORAGE_IDS:
  - "device1"
"""

import argparse
import os.path as osp
import shlex
import subprocess

import yaml
from utils import send_message

parser = argparse.ArgumentParser()
parser.add_argument("--settings-name", type=str, required=True)
parser.add_argument("--test", action="store_true")
parser.add_argument("--override-channel", type=str, default=None)
args = parser.parse_args()

with open(args.settings_name, "r") as f:
    settings = yaml.safe_load(f)
if args.override_channel is not None:
    settings["CHANNEL"] = args.override_channel

users = subprocess.Popen(
    shlex.split(
        f"sacctmgr show assoc format=User%30,Account%30 where account={settings['LAB']}"
    ),
    stdout=subprocess.PIPE,
).communicate()
users = [x.strip().split(" ")[0] for x in users[0].decode().split("\n")]
users = [x for x in users if x != ""]

child = subprocess.Popen(["df", "-h"], stdout=subprocess.PIPE)
output = child.communicate()
output = output[0].decode().strip().split("\n")

if args.test:
    send_message(settings, "Checking storage")

for x in output[1:]:
    if int(x.split()[-2][:-1]) >= settings["THRESHOLD"]:
        if x.split()[0] == "/dev/md2p1":
            continue

        is_valid_user = any(user in x for user in users)

        storage_id = x.split(" ")[0]
        is_valid_storage = any(storage_id.endswith(x) for x in settings["STORAGE_IDS"])

        if not (is_valid_user or is_valid_storage):
            continue
        send_message(settings, x)
