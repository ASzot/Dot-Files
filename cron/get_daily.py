import os
import os.path as osp
import random

home_dir = osp.expanduser("~")
write_dir = osp.join(home_dir, "Downloads", "daily")

os.makedirs(write_dir, exist_ok=True)

root_dir = osp.join(home_dir, "me")

for base_dir in ["research", "math_encyclopedia", "books"]:
    base_dir = osp.join(root_dir, base_dir)
    all_f = os.listdir(base_dir)
    f = random.choice(all_f)
    print(f"Trying {f}")
    full_f = osp.join(base_dir, f)
    cmd = f"pdflatex -output-directory {write_dir} {full_f}"
    print("Running", cmd)

    os.system(cmd)
