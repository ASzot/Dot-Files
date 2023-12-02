import os
import os.path as osp
import random

home_dir = osp.expanduser("~")
write_dir = osp.join(home_dir, "me", "daily_pdfs")

os.makedirs(write_dir, exist_ok=True)

root_dir = osp.join(home_dir, "me")

fetch = {"research": 2, "math_encyclopedia": 3, "books": 2}


for base_dir, count in fetch.items():
    base_dir = osp.join(root_dir, base_dir)
    all_f = [f for f in os.listdir(base_dir) if f.endswith(".tex")]

    for _ in range(count):
        f = random.choice(all_f)
        print("\n" * 5)
        print("-" * 10)
        print(f"Trying {f}")
        full_f = osp.join(base_dir, f)
        cmd = f"pdflatex -output-directory {write_dir} {full_f}"
        print("Running", cmd)

        os.system(cmd)
        # Try twice because if there is an error, you can go in and fix it.
        os.system(cmd)
