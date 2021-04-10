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

### List files in a bucket

#### Amazon S3

```bash
s3cmd \
--access_key=ABC \
--secret_key=ABC \
--region=eu-central-1 \
ls s3://your-bucket-url
```

#### Wasabi S3

```bash
s3cmd \
--access_key=ABC \
--secret_key=ABC \
--region=eu-central-1 \
--host=s3.eu-central-1.wasabisys.com \
--host-bucket="%(bucket)s.s3.wasabisys.com" \
ls s3://your-bucket-url
```

When you're working with Wasabi instead of Amazon AWS, make sure you include these:

```bash
--host=s3.eu-central-1.wasabisys.com
--host-bucket="%(bucket)s.s3.wasabisys.com"
```

Other regions include: 

- Wasabi US East 1 (N. Virginia): `s3.wasabisys.com` or `s3.us-east-1.wasabisys.com`
- Wasabi US East 2 (N. Virginia): `s3.us-east-2.wasabisys.com`
- Wasabi US Central 1 (Texas): `s3.us-central-1.wasabisys.com`
- Wasabi US West 1 (Oregon): `s3.us-west-1.wasabisys.com`
- Wasabi EU Central 1 (Amsterdam): `s3.eu-central-1.wasabisys.com`

### Download all files from S3 bucket:

```bash
s3cmd get \
--access_key=ABC \
--secret_key=ABC \
--region=eu-central-1 \
--recursive s3://your-bucket-url \
your-local-folder
```

### Upload all files to S3 bucket:

```bash
s3cmd put \
--access_key=ABC \
--secret_key=ABC \
--region=eu-central-1 \
--recursive your-local-folder/ \
s3://your-bucket-url
```

## See also

- [S3cmd (s3tools.org/s3cmd)](https://s3tools.org/s3cmd)
