---
---

**If you are running PantherX Desktop or Server, this is configured out of the box.**

Backup settings allows you to configure backup accounts you have setup in Online Accounts to actually do something.

- Online Accounts: Your backup account / destination (S3 or Wasabi)
- Backup Settings: The actual backup configuration

_Note:_ To backup to USB you don't need to setup a backup account first.

### Options

- Backup destination
- Backup interval: How often you want to backup
- Backup time: When you want to run the backup
- Included paths: What you want to include in the backup

You can a manual backup at any time with `px-backup-cli backup`.

If you have multiple accounts setup:

```bash
px-backup-cli list
px-backup-cli backup <ACCOUNT_ID>
```
