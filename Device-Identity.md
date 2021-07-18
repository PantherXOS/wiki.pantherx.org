---
---

PantherX Device Identity enables you to register you device with Central Management.

```bash
usage: .px-device-identity-real [-h] -o {INIT,SIGN,GET_JWK,GET_JWKS,GET_ACCESS_TOKEN} [-s {DEFAULT,TPM}] [-k {RSA:2048,RSA:3072,ECC:p256,ECC:p384,ECC:p521}] [-m MESSAGE] [-a ADDRESS] [-dn DOMAIN] [-t TITLE]
                                [-l LOCATION] [-r {PUBLIC,DESKTOP,SERVER,ADMIN_TERMINAL,REGISTRATION_TERMINAL,OTHER}] [-f {True,False}] [-d DEBUG]
.px-device-identity-real: error: the following arguments are required: -o/--operation
```

## Installation

```bash
# su - root
guix package -i px-device-identity
```

Additionally, a service is available to allow non-root users to access signing capabilities:

```bash
# su - root
guix package -i px-device-identity-service
```

## Troubleshooting

### Unsupported device. The device is a TPM 1.2

If you use flag `-s TPM` a TPM 2 device is assumed to be available.

```
ERROR:sys:src/tss2-sys/api/Tss2_Sys_Execute.c:114:Tss2_Sys_ExecuteFinish() Unsupported device. The device is a TPM 1.2 
ERROR:esys:src/tss2-esys/api/Esys_GetCapability.c:307:Esys_GetCapability_Finish() Received a non-TPM Error 
ERROR:esys:src/tss2-esys/api/Esys_GetCapability.c:107:Esys_GetCapability() Esys Finish ErrorCode (0x00080001) 
Error: Generating key failed
```

You can check your current version like so:

```bash
$ dmesg | grep -i tpm
```

For TPM 1.2, it will looks something like this:

```bash                                                                                                          
[    0.010985] ACPI: SSDT 0x00000000CCDD7000 0006B0 (v02 Intel_ TpmTable 00001000 INTL 20120711)
[    0.494929] tpm_tis 00:05: 1.2 TPM (device-id 0x0, rev-id 78)
```

For TPM 2.0 like this:

```bash
[    0.000000] efi: ACPI 2.0=0x6e5f4000 ACPI=0x6e5f4000 TPMFinalLog=0x6e65c000 SMBIOS=0x6eac7000 SMBIOS 3.0=0x6eac6000 ESRT=0x6baffd18 MEMATTR=0x69ccb018 
[    0.008965] ACPI: TPM2 0x000000006E63F498 000034 (v04 ALASKA A M I    00000001 AMI  00000000)
[    0.008992] ACPI: Reserving TPM2 table memory at [mem 0x6e63f498-0x6e63f4cb]
```

If your device reports a TPM 1.2, you should check if your device supports TPM 2.0. Sometimes it's possible to enable this in BIOS.

If your device does not support TPM 2.0, you should register with flag `-s DEFAULT` which will store the keys in files rather than the much more secure TPM.