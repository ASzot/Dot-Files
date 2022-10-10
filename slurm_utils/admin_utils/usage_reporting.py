import subprocess
import requests
import yaml
import os.path as osp
import shlex

SETTINGS_FILE = osp.join(osp.expanduser("~"), ".admin_script_info.yaml")

with open(SETTINGS_FILE, "r") as f:
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

        payload = (
            '{"channel": "%s", "username": "%s", "text": "[Skynet space] %s"}'
            % (settings["CHANNEL"], settings["USER"], x)
        )
        requests.post(settings["SLACK_ENDPOINT"], data=payload)
