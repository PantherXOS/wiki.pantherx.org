---
namespace: diff
description: "In computing, the diff utility is a data comparison tool that calculates and displays the differences between two files. Unlike edit distance notions used for other purposes, diff is line-oriented rather than character-oriented, but it is like Levenshtein distance in that it tries to determine the smallest set of deletions and insertions to create one file from the other. The diff command displays the changes made in a standard format, such that both humans and machines can understand the changes and apply them: given one file and the changes, the other file can be created."
description-source: "https://en.wikipedia.org/wiki/Diff"
categories:
 - type:
   - "Application"
   - "CI"
 - location:
   - "General"
language: en
---

## Usage

To compare two folders, do:

```bash
$ diff -q folder1/ folder2/
```

To compare two folders, including all contained folders, do:

```bash
$ diff -qr folder1/ folder2/
```