---
namespace: aws
description: "The AWS Command Line Interface (CLI) is a unified tool to manage your AWS services. With just one tool to download and configure, you can control multiple AWS services from the command line and automate them through scripts."
description-source: ""
categories:
 - type:
   - "Application"
 - location:
   - "Development"
   - "Version Control System"
language: en
---

## Installation

```bash
$ guix package -i awscli
```

### Configure

#### General

You may optionally configure some defaults:

```bash
$ aws configure
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]: eu-central-1
Default output format [None]: json
```

The result will be stored at `~/.aws`.

#### Credentials

Optionally, you may store some credentials for easier access at `~/.aws/credentials`:

```
[default]
aws_access_key_id=AKDAIOSFAQNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFHDI/K7MDENG/bPxRfiUYEXAMPLEKEY

[someunixsite.com]
aws_access_key_id=OPDAIOSFAQNN7EXAMPEA
aws_secret_access_key=wkalrXUtnFHDI/K7MDENG/bPxRfiUYEXAMPLEKIO
```

### Usage

For most CLI command you can simply append the profile name:

```
aws ... -profile someunixsite.com
```

Or set it via ENV:

```
AWS_PROFILE=someunixsite.com
```
