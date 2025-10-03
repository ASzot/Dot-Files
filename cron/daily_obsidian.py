import os
import os.path as osp
import random
import re
from datetime import datetime
from pathlib import Path

BASE_DIR = "/Users/andrewszot/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes-synced"

NOTE_COUNTS = {"math_encyclopedia": 10, "research": 10, "books/content": 4}

SUB_COUNTS = {
    "math_encyclopedia": "summary/math/analysis/manifolds/",
}


def get_files_in_directory(directory):
    """Get all .md files in the specified directory."""
    full_path = os.path.join(BASE_DIR, directory)
    if not os.path.exists(full_path):
        print(f"Warning: Directory {full_path} does not exist")
        return []

    files = []
    for file in os.listdir(full_path):
        if file.endswith(".md"):
            files.append(file)
    return files


def find_all_names_in_dir(search_dir):
    pattern = re.compile(r"^\s*[-*]\s*\[\[([^\]\|#]+?)\]\]", re.MULTILINE)

    search_dir = Path(osp.join(BASE_DIR, search_dir)).expanduser().resolve()
    names = set()
    for md in search_dir.rglob("*.md"):
        try:
            text = md.read_text(encoding="utf-8", errors="ignore")
        except Exception:
            continue
        for m in pattern.finditer(text):
            names.add(m.group(1).strip())
    return names


def create_review_file():
    """Create a review.md file with random selections from each directory."""
    review_content = f"# Daily Review - {datetime.now().strftime('%Y-%m-%d')}\n\n"

    for directory, count in NOTE_COUNTS.items():
        # Add a section header for each directory
        section_name = directory.replace("/", " - ").title()
        review_content += f"## {section_name}\n"

        # Get all files in the directory
        files = get_files_in_directory(directory)

        if not files:
            review_content += f"*No files found in {directory}*\n\n"
            continue

        # Select random files up to the count (or fewer if not enough files)
        selected_files = random.sample(files, min(count, len(files)))

        # Add links to the selected files
        for file in selected_files:
            # Remove the .md extension for the wiki link
            file_name = os.path.splitext(file)[0]
            review_content += f"- [[{file_name}]]\n"

        review_content += "\n"

        if directory in SUB_COUNTS:
            review_content += f"### Section Specific Review\n"
            names = find_all_names_in_dir(SUB_COUNTS[directory])
            ref_files = [name + ".md" for name in names]
            ref_files = [file for file in ref_files if file in files]
            selected_files = random.sample(ref_files, min(count, len(ref_files)))
            for file in selected_files:
                # Remove the .md extension for the wiki link
                file_name = os.path.splitext(file)[0]
                review_content += f"- [[{file_name}]]\n"
        review_content += "\n"

    # Write to review.md in the base directory
    with open(os.path.join(BASE_DIR, "review.md"), "w") as f:
        f.write(review_content)

    print(f"Created review.md at {os.path.join(BASE_DIR, 'review.md')}")


if __name__ == "__main__":
    create_review_file()
