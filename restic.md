---
namespace: restic
description: "Restic is a modern backup program that can back up your files"
description-source: ""
categories:
  - type:
      - "Application"
  - location:
      - "Development"
language: en
---

## Create a Backuo

Up until a few years ago, I mostly used interface-driven backup applications. In some cases, these would spare me from reading a manual, or opening the terminal. However, even I have come to realize the value of a simple, terminal driven application - that usually has fewer bugs, is much faster and can be automated (scripted) easily.

**restic** is an example of that; We'll use that below.

Here's how-to create an encrypted backup on the command line:

1. First of all, plugin the external HDD you want to backup to
   - I'm assuming it's already formatted and ready to go
   - By default, you should be prompted whether to open the drive (and thus mount it)
   - It should be mounted at `/home/your_username/some-long-uuid-string-....
2. Open up the Terminal: Menu > System Tools > Terminal

Install the backup application:

```bash
guix package -i restic
```

Find out where where your drive is mounted:

```bash
$ ls /media/your_username

# example: ls /media/franz
# 68bcdc8a-3661-4c0a-81ce-4d5077a1367f/
```

I'd suggest to create a sub-folder for the backup. For ex.

```bash
mkdir /media/your_username/some-long-uuid-string/backup
# example: mkdir /media/franz/68bcdc8a-3661-4c0a-81ce-4d5077a1367f/backup
```

Now you can configure your backup. This will prompt you for an encryption password.

```bash
restic init --repo /media/your_username/some-long-uuid-string/backup
# example: restic init --repo /media/franz/68bcdc8a-3661-4c0a-81ce-4d5077a1367f/backup
```

Next, create a bash file, to easily run the backup, whenever the drive is attached. For this, you can use your preferred text-editor; here's how-to open `nano`:

```bash
nano ~/backup.sh
```

If you simply want to backup all your files, with a few exclusions (I have quite a _few_), write something like this into the `backup.sh` (make sure to use your username and backup location path!):

```sh
restic -r /media/franz/68bcdc8a-3661-4c0a-81ce-4d5077a1367f/backup --verbose backup /home/franz \
--exclude /home/franz/Android \
--exclude /home/franz/.android \
--exclude /home/franz/.npm \
--exclude /home/franz/.NPM_GLOBAL \
--exclude /home/franz/.npm-packages \
--exclude /home/franz/.pm2 \
--exclude /home/franz/.var \
--exclude /home/franz/.cache \
--exclude /home/franz/.cargo \
--exclude /home/franz/.gradle \
--exclude /home/franz/.local/share/flatpak \
--exclude /home/franz/.local/share/Trash \
--exclude /home/franz/.java \
--exclude /home/franz/.kde \
--exclude /home/franz/.dbus \
--exclude /home/franz/.recoll \
--exclude /home/franz/.recollweb
```

Write the file with `STRG + O`. Confirm the file name. Close with `STRG + X`.

Now simply run the file, whenever you want to backup (assuming the drive is attached):

```sh
bash backup.sh
```

You will be prompted for your backup password.

If you've made it this far, here's some more links to checkout:

- https://restic.readthedocs.io/en/stable/050_restore.html
- https://restic.readthedocs.io/en/stable/060_forget.html

A couple of notes:

- You should definitely look into removing old snapshots
  - for ex. `restic -r ./backup forget --keep-last 14 --prune`
- `restic` does not check if there's enough disk space, to complete the backup

I haven't automated this yet, but once I do, I'll make sure to share it here. 