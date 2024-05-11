import argparse
import glob
import math
import os.path as osp

import tqdm

BLACKLIST = {"datasets"}


def human_format(number):
    prefixes = [
        (1, "K"),
        (1024, "M"),
        (1024 ** 2, "G"),
        (1024 ** 3, "T"),
        (1024 ** 4, "P"),
    ]

    for div, pre in prefixes:
        human_num = float(number) / float(div)
        if human_num < 1024:
            human_num = math.ceil(human_num * 10) / 10
            return "%6.1f" % human_num + pre


def main():
    parser = argparse.ArgumentParser(
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument("base_dirs", type=str, nargs="+")
    parser.add_argument(
        "--min-print-usage",
        help="Minimum usage for a user's name to be printed (in GB)",
        type=float,
        default=1024 * 2,
    )

    args = parser.parse_args()
    args.min_print_usage *= 1024 * 1024

    usage_by_name = dict()
    for base_dir in tqdm.tqdm(args.base_dirs, leave=False):
        for d in tqdm.tqdm(glob.glob(osp.join(base_dir, "*")), leave=False):
            if not osp.isdir(d):
                continue
            usage_file = osp.join(d, "disk-usage.txt")
            if not osp.exists(usage_file):
                continue

            name = osp.basename(d)
            if name in BLACKLIST:
                continue

            with open(usage_file, "r") as f:
                usage = f.read().split("\n")[2]
                usage = float(usage.split(":")[1])

            usage_by_name[name] = usage_by_name.get(name, 0) + usage
    usages = list(usage_by_name.items())

    usages = sorted(usages, key=lambda v: v[1], reverse=True)
    usages = list(filter(lambda v: v[1] >= args.min_print_usage, usages))
    longest_user_name = max(len(v[0]) for v in usages)

    for user, usage in usages:
        print(
            "{:{padding}} {}".format(
                user, human_format(usage), padding=longest_user_name
            )
        )


if __name__ == "__main__":
    main()
