import json

import requests


def send_message(settings, txt):
    post_data = {}
    if settings["CHANNEL"] is not None:
        post_data["channel"] = settings["CHANNEL"]

    if settings["USER"] is not None:
        post_data["username"] = settings["USER"]
    post_data["text"] = f"[Skynet space] {txt}"
    payload = json.dumps(post_data)

    requests.post(settings["SLACK_ENDPOINT"], data=payload)
