import os
import random
from datetime import datetime

BASE_DIR = "/Users/andrewszot/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes-synced"

NOTE_COUNTS = {
    "math_encyclopedia": 4,
    "research": 2,
    "books/content": 2
}

def get_files_in_directory(directory):
    """Get all .md files in the specified directory."""
    full_path = os.path.join(BASE_DIR, directory)
    if not os.path.exists(full_path):
        print(f"Warning: Directory {full_path} does not exist")
        return []
    
    files = []
    for file in os.listdir(full_path):
        if file.endswith('.md'):
            files.append(file)
    return files

def create_review_file():
    """Create a review.md file with random selections from each directory."""
    review_content = f"# Daily Review - {datetime.now().strftime('%Y-%m-%d')}\n\n"
    
    for directory, count in NOTE_COUNTS.items():
        # Add a section header for each directory
        section_name = directory.replace('/', ' - ').title()
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
    
    # Write to review.md in the base directory
    with open(os.path.join(BASE_DIR, "review.md"), "w") as f:
        f.write(review_content)
    
    print(f"Created review.md at {os.path.join(BASE_DIR, 'review.md')}")

if __name__ == "__main__":
    create_review_file()