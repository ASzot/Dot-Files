import os.path as osp
import pandas as pd
import datetime
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap

cmp = ListedColormap(["white", "black"])

home_dir = osp.expanduser("~")
use_path = osp.join(home_dir, "Downloads/BeFocused.csv")

date_range = 7
now = datetime.datetime.now().date()
prev_days = [now - datetime.timedelta(days=i) for i in range(date_range)]

df = pd.read_csv(use_path, index_col="Start date", parse_dates=True)
start = prev_days[-1].strftime("%Y-%m-%d")
df = df[start:]

all_day_dat = {k: v for k, v in df.groupby(df.index.date)}

minutes = np.zeros((60 * 24, date_range), dtype=np.int32)
X = np.arange(minutes.shape[1])
Y = np.arange(minutes.shape[0])

for day_i, day in enumerate(prev_days):
    day_df = all_day_dat[day]
    for name, row in day_df.iterrows():
        start_time = (name.hour * 60) + (name.minute)
        end_time = int(start_time + row[" Duration"])
        minutes[start_time:end_time, day_i] = 1

fig, ax = plt.subplots()
# ax.imshow(minutes, interpolation="none", cmap=cmp)
ax.pcolormesh(X, Y, minutes, cmap=cmp)
ax.set_xticks(X, labels=[x.strftime("%a") for x in prev_days])


def get_date_id(x):
    if x == 0:
        return ""
    elif x < 12:
        return f"{x}am"
    elif x == 12:
        return f"{x}pm"
    else:
        return f"{x - 12}pm"


ax.set_yticks(
    [i * 60 for i in range(24)], labels=[get_date_id(h) for h in range(24)]
)
ax.grid(which="major", color="gray", linestyle="-", linewidth=0.5)

fig.tight_layout()
ax.set_aspect(aspect="auto")
fig.savefig(
    osp.join(home_dir, "Downloads/daily/time.pdf"),
    bbox_inches="tight",
    dpi=100,
)
