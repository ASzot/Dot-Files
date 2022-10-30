import os
import os.path as osp
import random

home_dir = osp.expanduser("~")
write_dir = osp.join(home_dir, "Downloads", "daily")

os.makedirs(write_dir, exist_ok=True)

root_dir = osp.join(home_dir, "me")

fetch = {"research": 1, "math_encyclopedia": 2, "books": 1}


for base_dir, count in fetch.items():
    base_dir = osp.join(root_dir, base_dir)
    all_f = os.listdir(base_dir)

    for _ in range(count):
        f = random.choice(all_f)
        print(f"Trying {f}")
        full_f = osp.join(base_dir, f)
        cmd = f"pdflatex -output-directory {write_dir} {full_f}"
        print("Running", cmd)

        os.system(cmd)
