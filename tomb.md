---
namespace: tomb
description: "Tomb is an 100% free and open source system for file encryption on GNU/Linux, facilitating the backup of secret files."
description-source: "https://www.dyne.org/software/tomb/"
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
guix package -i tomb file
```

## Usage

For the sake of this tutorial, I've created a `tomb_test` folder:

```bash
mkdir tomb_test && cd tomb_test
```

**Note** most of our commands include a `-f` flag which causes `tomb` to ignore the fact that I'm using a swap file (and if you're on a default PantherX OS install, so do you.). This is not ideal because by chance, some of the things we try to keep secret, may end-up in that swap file until they are overwritten by other data. If you would like to temporarily disable swap, you may do so:

```bash
su - root
swapoff /swapfile
# swapon /swapfile to re-enable it
```

### Create key

First create a key with which to secure the store (tomb). You will be prompted for a password, that secures the key itself.

The `secret.tomb.key` is the filename of the key file you would like to create

```bash
$ tomb forge secret.tomb.key -f
.tomb-real  .  Commanded to forge key secret.tomb.key with cipher algorithm AES256
.tomb-real [W] This operation takes time. Keep using this computer on other tasks.
.tomb-real [W] Once done you will be asked to choose a password for your tomb.
.tomb-real [W] To make it faster you can move the mouse around.
.tomb-real [W] If you are on a server, you can use an Entropy Generation Daemon.
512+0 records in
512+0 records out
512 bytes copied, 0.00206366 s, 248 kB/s
.tomb-real (*) Choose the password of your key: secret.tomb.key
.tomb-real  .  (You can also change it later using 'tomb passwd'.)
.tomb-real  .  Key is valid.
.tomb-real  .  Done forging secret.tomb.key
.tomb-real (*) Your key is ready:
-rw------- 1 franz users 859 Feb  3 09:47 secret.tomb.key
```

### Create store

Once you have a key, you can create a new store (tomb).

The `100` stands for Megabytes as in the size of your store (100MB). `secret.tomb` is the name of your store. Maybe don't use such an obvious name.

```bash
$ tomb dig -s 100 secret.tomb -f
.tomb-real  .  Commanded to dig tomb
.tomb-real (*) Creating a new tomb in secret.tomb
.tomb-real  .  Generating secret.tomb of 100MiB
100+0 records in
100+0 records out
104857600 bytes (105 MB, 100 MiB) copied, 0.495994 s, 211 MB/s
-rw------- 1 franz users 100M Feb  3 09:57 secret.tomb
.tomb-real (*) Done digging secret.tomb
.tomb-real  .  Your tomb is not yet ready, you need to forge a key and lock it:
.tomb-real  .  tomb forge secret.tomb.key
.tomb-real  .  tomb lock secret.tomb -k secret.tomb.key
```

### Encrypt store

Now it's time to encrypt the tomb with the key you created earlier. You will be promted for the password you used to secure the key.

```bash
$ tomb lock secret.tomb -k secret.tomb.key
.tomb-real [W] File is not yet a tomb: secret.tomb
.tomb-real  .  Valid tomb file found: secret.tomb
.tomb-real  .  Commanded to lock tomb secret.tomb
.tomb-real  .  Checking if the tomb is empty (we never step on somebody else's bones).
.tomb-real  .  Fine, this tomb seems empty.
.tomb-real  .  Key is valid.
.tomb-real  .  Locking using cipher: aes-xts-plain64
.tomb-real  .  A password is required to use key secret.tomb.key
.tomb-real  .  Password OK.
.tomb-real (*) Locking secret.tomb with secret.tomb.key
.tomb-real  .  Formatting Luks mapped device.
.tomb-real  .  Formatting your Tomb with ext4 filesystem.
.tomb-real  .  Done locking secret using Luks dm-crypt aes-xts-plain64
.tomb-real (*) Your tomb is ready in secret.tomb and secured with key secret.tomb.key
```

### Open store

To actually add data to the store, open it with the key file. You will be prompted for your user password and then the key-file password. The user password (with superuser priviliges) is necessary to mount the store under `/media/secret` and makes it accessible via file browser.

```bash
$ tomb open secret.tomb -k secret.tomb.key -f
.tomb-real  .  Commanded to open tomb secret.tomb

[sudo] Enter password for user franz to gain superuser privileges


.tomb-real  .  Valid tomb file found: secret.tomb
.tomb-real  .  Key is valid.
.tomb-real  .  Mountpoint not specified, using default: /media/secret
.tomb-real (*) Opening secret on /media/secret
.tomb-real  .  This tomb is a valid LUKS encrypted device.
.tomb-real  .  Cipher is "aes" mode "xts-plain64" hash "sha512"
.tomb-real  .  A password is required to use key secret.tomb.key
.tomb-real  .  Password OK.
.tomb-real (*) Success unlocking tomb secret
.tomb-real  .  Filesystem detected:
.tomb-real  .  Checking filesystem via /dev/loop0
.tomb-real (*) Success opening secret.tomb on /media/secret
```

{% include snippets/screenshot.html image='tomb/mounted-tomb-store-in-file-explorer.png' alt="Encrypted tomb store mounted in file exlorer." %}

### Close store

Always make sure your store is closed after using it (or before shutting down your computer).

```bash
$ tomb close

[sudo] Enter password for user franz to gain superuser privileges

.tomb-real . Closing tomb [secret] mounted on /media/secret
.tomb-real (\*) Tomb [secret] closed: your bones will rest in peace.
```

## Secure your keys

These steps are optional but will greatly enhance the security of your store.

### Hide key in a JPG image

An interesting way to hide your key, is to use a JPG image to store the key. Here's how-to do that:

```bash
guix package -i steghide
```

Now we need a JPG image; I copied one from my Pictures folder to `tomb_test`:

```bash
$ cp ~/Pictures/Some.jpg .
$ ls
secret.tomb  secret.tomb.key  Some.jpg
```

To embed the key in the JPG:

```bash
$ tomb bury -k secret.tomb.key Some.jpg
.tomb-real  .  Key is valid.
.tomb-real (*) Encoding key
-----BEGIN PGP MESSAGE-----

...

-----END PGP MESSAGE-----
 inside image Some.jpg

.tomb-real  .  Please confirm the key password for the encoding
.tomb-real  .  A password is required to use key secret.tomb.key
.tomb-real  .  Password OK.
embedding standard input in "Some.jpg"... done
.tomb-real (*) Tomb key encoded succesfully into image Some.jpg
```

You can now delete your key with:

```bash
rm secret.tomb.key
```

To retrieve the key file:

```bash
$ tomb exhume -k secret.tomb.key Some.jpg
.tomb-real  .  Trying to exhume a key out of image Some.jpg
/home/franz/.gtkrc-2.0:11: error: unexpected end of file, expected number (integer)

(pinentry-gtk-2:15737): Gtk-WARNING **: 11:05:23.679: Unable to locate theme engine in module_path: "adwaita",
wrote extracted data to "secret.tomb.key".
.tomb-real (*) Key succesfully exhumed to secret.tomb.key.
```

Bonus: To get determine whether a file has a key:

```bash
$ steghide info Some.jpg
"Some.jpg":
  format: jpeg
  capacity: 25.1 KB
Try to get information about embedded data ? (y/n) y
Enter passphrase:
  embedded data:
    size: 806.0 Byte
    encrypted: serpent, cbc
    compressed: yes
```

### Store the keys on a USB Stick or microSD card

If you want to make sure that your secret store is mostly useless, make sure that you store the key, or even better, the JPG that contains the key, in a seperate location.

## See also

- [dyne.org/software/tomb/](https://www.dyne.org/software/tomb/)
