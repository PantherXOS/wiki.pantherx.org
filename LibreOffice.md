---
namespace: libreoffice
description: "LibreOffice is a free and open-source office suite, a project of The Document Foundation. It was forked in 2010 from OpenOffice.org, which was an open-sourced version of the earlier StarOffice. The LibreOffice suite consists of programs for word processing, creating and editing of spreadsheets, slideshows, diagrams and drawings, working with databases, and composing mathematical formulae. It is available in 115 languages."
description-source: "https://en.wikipedia.org/wiki/LibreOffice"
categories:
 - type:
   - "Application"
 - location:
   - "General"
   - "Office"
language: en
---

## Installation

If LibreOffice is not pre-installed on your Desktop, here's how to install it:

```bash
$ guix package -i libreoffice
```

## Troubleshooting

### No spell checker is available

To get spell checking to work, install the required dictionaries.

First, find the dictionaries you'll need:

```bash
$ guix package -s hunspell-*
```

For example, to install US-english support, do:

```bash
$ guix package -i hunspell-dict-en hunspell-dict-en-us
```

Activate using

1. Tools
2. Options
3. Language Settings
4. Writing Aids
5. Available language modules

Select "Huntspell SpellChecker"
