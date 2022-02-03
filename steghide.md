---
namespace: steghide
description: "Steghide is a steganography program that is able to hide data in various kinds of image- and audio-files. The color- respectivly sample-frequencies are not changed thus making the embedding resistant against first-order statistical tests."
description-source: "http://steghide.sourceforge.net/index.php"
categories:
  - type:
      - "Application"
  - location:
      - "Tools"
      - "Encryption"
language: en
---

## Installation

```bash
guix package -i steghide
```

## Usage

An interesting way to hide a key, is to use a JPG image to store the key. Here's how-to do that:

We need a JPG image; I copied one from my Pictures folder to `tomb_test`:

```bash
$ cp ~/Pictures/Some.jpg .
$ ls
secret.tomb  secret.tomb.key  Some.jpg
```

To embed the key in the JPG (this will prompt you for a passphrase which should be different from the one you used to secure the key):

```bash
$ steghide embed -cf Some.jpg -ef secret.tomb.key
Enter passphrase:
Re-Enter passphrase:
embedding "secret.tomb.key" in "Some.jpg"... done
```

You can now delete your key with:

```bash
rm secret.tomb.key
```

To retrieve the key file:

```bash
$ steghide extract -sf Some.jpg
Enter passphrase:
wrote extracted data to "secret.tomb.key".
```

Bonus: To get determine whether a file has a key:

```bash
$ steghide info Some.jpg
"Some.jpg":
  format: jpeg
  capacity: 25.1 KB
Try to get information about embedded data ? (y/n) y
Enter passphrase:
  embedded file "secret.tomb.key":
    size: 859.0 Byte
    encrypted: rijndael-128, cbc
    compressed: yes
```

## See also

- [steghide.sourceforge.net](http://steghide.sourceforge.net/index.php)
