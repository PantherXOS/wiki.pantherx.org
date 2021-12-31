---
---

## Online Accounts

**If you are running PantherX Desktop, this is configured out of the box.**

Accounts (or Online Accounts) is a great place to manage all your accounts.

The number of supported providers and applications is growing steadily. At the time of writing:

- Gitlab (with Hub)
- Etherscan
- GitHub (with Hub)
- BlockIO
- Email (Yahoo, Google, Soverin, GMX, Posteo, ..)
- SMTP / IMAP
- Encrypted Backup to S3 / Wasabi / Hard Disk
- Mastodon (with Hub)
- Discource (with Hub)

Accounts "with Hub" support, will trigger notifications in PantherX Hub right on your desktop.

### Technicals

All your accounts are stored in yaml format at `~/.local/share/px-accounts-service/accounts`. Secrets are stored in the system keychain, protected by your account password.
