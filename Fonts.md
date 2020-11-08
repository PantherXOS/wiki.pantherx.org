---
namespace: fonts
description: 'In modern usage, with the advent of digital typography, "font" is frequently synonymous with "typeface". Each style is in a separate "font file"—for instance, the typeface "Bulmer" may include the fonts "Bulmer roman", "Bulmer", "Bulmer bold" and "Bulmer extended"—but the term "font" might be applied either to one of these alone or to the whole typeface.'
description-source: "https://en.wikipedia.org/wiki/Font"
categories:
 - type:
   - "Application"
 - location:
   - "General"
language: en
---

## Installation

There are various ways to add new fonts to your system. Often it depends on what you're planning to do with them, that dictates what approach you should take.

### Package Manager

Many fonts are available via package. Just search and install ...

```sh
$ guix package -s font-*

name: font-ubuntu
version: 0.83
outputs: out
systems: x86_64-linux i686-linux
dependencies: 
location: gnu/packages/fonts.scm:120:2
homepage: http://font.ubuntu.com/
license: non-copyleft
synopsis: The Ubuntu Font Family  
description: The Ubuntu Font Family is a unique, custom designed font that has a very distinctive look and feel.  This package provides the TrueType (TTF) files.
relevance: 12

name: font-terminus
version: 4.48
outputs: out pcf-8bit
systems: x86_64-linux i686-linux
dependencies: bdftopcf@1.1 font-util@1.3.2 mkfontdir@1.0.7 pkg-config@0.29.2 python@3.8.2
location: gnu/packages/fonts.scm:418:2
homepage: http://terminus-font.sourceforge.net/
license: SIL OFL 1.1
synopsis: Simple bitmap programming font  
description: Terminus Font is a clean, fixed-width bitmap font, designed for long periods of working with computers (8 or more hours per day).
relevance: 12
```

and install with:

```sh
$ guix package -i font-terminus
```

### Manually (user only)

If you prefer to manage fonts manually, or use licensed fonts that are not packaged, you can simply drop them in a folder, in your user home directory.

```sh
$ mkdir ~/.fonts
```

and now move your desired fonts there. For ex.

```sh
$ ls ~/.fonts/Metropolis/
 Metropolis-BlackItalic.otf   Metropolis-ExtraBoldItalic.otf    Metropolis-LightItalic.otf    Metropolis-RegularItalic.otf    Metropolis-ThinItalic.otf
 Metropolis-Black.otf         Metropolis-ExtraBold.otf          Metropolis-Light.otf          Metropolis-Regular.otf          Metropolis-Thin.otf
 Metropolis-BoldItalic.otf    Metropolis-ExtraLightItalic.otf   Metropolis-MediumItalic.otf   Metropolis-SemiBoldItalic.otf  'SIL Open Font License.txt'
 Metropolis-Bold.otf
```

Applications such as Inkscape, Gimp or Libre Office should automatically recognize the new fonts. In some cases, you may have to restart the target application first.

## Troubleshooting

### Fonts in GTK+ applications appear distortet

If your fonts look scrambled or distortet in GTK+ applications, it helps to clear the font cache:

```sh
fc-cache -f
```

Restart the application, or even better, reboot.
