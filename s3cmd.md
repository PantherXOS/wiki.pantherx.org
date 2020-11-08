---
namespace: python
description: "S3cmd is a command line tool for uploading, retrieving and managing data in storage services that are compatible with the Amazon Simple Storage Service (S3) protocol, including S3 itself. It supports rsync-like backup, GnuPG encryption, and more. It also supports management of Amazon's CloudFront content delivery network."
description-source: ""
categories:
 - type:
   - "Application"
 - location:
   - "Development"
language: en
---

## Installation

```bash
guix package -i python2-s3cmd
```

## Usage

I usually use this to verify S3 credentials, but of course you can do _much_ more with this.

```bash
s3cmd --access_key=ABC --secret_key=ABC --region=eu-central-1 --host=s3.eu-central-1.wasabisys.com --host-bucket="%(bucket)s.s3.wasabisys.com" ls s3://your-bucket-url
```