import subprocess
import requests
import yaml
import os.path as osp
import shlex
import argparse
import json


def send_message(settings, txt):
    post_data = {}
    if settings["CHANNEL"] is not None:
        post_data["channel"] = settings["CHANNEL"]

    if settings["USER"] is not None:
        post_data["username"] = settings["USER"]
    post_data["text"] = f"[Skynet space] {txt}"
    payload = json.dumps(post_data)

    requests.post(settings["SLACK_ENDPOINT"], data=payload)


parser = argparse.ArgumentParser()
parser.add_argument("--settings-name", type=str, required=True)
args = parser.parse_args()

settings_file = osp.join(osp.expanduser("~"), f".{args.settings_name}.yaml")

with open(settings_file, "r") as f:
    settings = yaml.safe_load(f)

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

for x in output[1:]:
    if int(x.split()[-2][:-1]) >= settings["THRESHOLD"]:
        if x.split()[0] == "/dev/md2p1":
            continue

        is_valid_user = any(user in x for user in users)

        storage_id = x.split(" ")[0]
        is_valid_storage = any(
            storage_id.endswith(x) for x in settings["STORAGE_IDS"]
        )

        if not (is_valid_user or is_valid_storage):
            continue
        send_message(settings, x)
