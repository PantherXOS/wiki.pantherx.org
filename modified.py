import argparse
import os
import subprocess
from datetime import datetime
import yaml
import re

blacklist = ['README.md']

def get_last_modified_date(file_path):
    result = subprocess.run(
        ["git", "log", "-1", "--pretty=format:%ci", file_path],
        stdout=subprocess.PIPE,
    )
    # The date will be in bytes, we need to decode it
    date = result.stdout.decode("utf-8")
    # Return only date and time, remove timezone
    if date:
        return date[:19]
    else:
        return None


def add_modified_date(file_path, date, dry_run):
    with open(file_path, 'r+') as f:
        content = f.read()
        yaml_block = re.findall(r"^---\n(.*?)^---$", content, re.MULTILINE | re.DOTALL)
        yaml_content = {}

        if yaml_block:
            try:
                yaml_content = yaml.safe_load(yaml_block[0]) or {}
            except yaml.YAMLError as e:
                print(f"Error parsing YAML in file {file_path}: {e}")
                return

        yaml_content["modified"] = date

        new_front_matter = "---\n" + yaml.dump(yaml_content, sort_keys=False) + "---\n"
        new_content = re.sub(r"^---\n(.*?)^---$", lambda _: new_front_matter, content, flags=re.MULTILINE | re.DOTALL)

        if dry_run:
            print(f"DRY-RUN\n- {date} - {file_path}: would prepend modified date")
        else:
            f.seek(0)
            f.write(new_content)
            f.truncate()
            print(f"DRY-RUN: False\n- {date} - {file_path}: updated")


def process_files(dry_run):
    for file in os.listdir("."):
        if file.endswith(".md") and file not in blacklist:
            date = get_last_modified_date(file)
            if date:
                add_modified_date(file, date, dry_run)

def parse_args():
    parser = argparse.ArgumentParser(description="Update last modified dates.")
    parser.add_argument("--dry-run", dest="dry_run", action='store_true',
                        help="Run the script in dry-run mode, without making any changes.")
    parser.add_argument("--no-dry-run", dest="dry_run", action='store_false',
                        help="Run the script in actual mode, with making changes.")
    parser.set_defaults(dry_run=True)
    return parser.parse_args()

def main():
    args = parse_args()
    process_files(args.dry_run)

if __name__ == "__main__":
    main()