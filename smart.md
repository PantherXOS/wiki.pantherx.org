---
namespace: smart
description: "Self-Monitoring, Analysis and Reporting Technology (S.M.A.R.T., often written as SMART) is a monitoring system included in computer hard disk drives (HDDs) and solid-state drives (SSDs). Its primary function is to detect and report various indicators of drive reliability with the intent of anticipating imminent hardware failures."
description-source: "https://en.wikipedia.org/wiki/Self-Monitoring,_Analysis_and_Reporting_Technology"
categories:
  - type:
      - "Monitoring"
  - location:
      - "Development"
language: en
---

## Check your HDD health

I regularly backup my system to an external hard disk but I've recently grown concerned that it might be failing. Fortunately there's a bunch of useful open source tools, that should help me determine what's going on.

We'll be using `smartmontools` which is already available on PantherX.

```bash
guix package -i smartmontools
```

Once it's installed, you simply point it at the disk (list available disks with `lsblk`):

```bash
smartctl /dev/sda
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.19.5] (Guix)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

sda: Unknown USB bridge [0x059f:0x10c4 (0x003)]
Please specify device type with the -d option.

Use smartctl -h to get a usage summary
```

This doesn't work; Let's check the smartmontools website for [supported USB devices](https://www.smartmontools.org/wiki/Supported_USB-Devices). I couldn't find my specific device (`0x059f:0x10c4`) but several other Lacie HDD's with the option: `-d sat`.

Let's give that a try:

```bash
sudo smartctl --all /dev/sda -d sat
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.19.5] (Guix)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Mobile HDD
Device Model:     ST2000LM007-1R8174
Serial Number:    ZDZHZLQD
LU WWN Device Id: 5 000c50 0dc0eaac6
Firmware Version: EB01
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      2.5 inches
TRIM Command:     Available
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sun Oct 16 11:05:19 2022 WEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever 
                                        been run.
Total time to complete Offline 
data collection:                (    0) seconds.
Offline data collection
capabilities:                    (0x71) SMART execute Offline immediate.
                                        No Auto Offline data collection support.
                                        Suspend Offline collection upon new
                                        command.
                                        No Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine 
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 334) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x3035) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   081   065   006    Pre-fail  Always       -       226628847
  3 Spin_Up_Time            0x0003   100   100   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       40
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   072   060   045    Pre-fail  Always       -       14697043
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       402 (11 98 0)
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       39
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age   Always       -       0
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0022   068   051   040    Old_age   Always       -       32 (Min/Max 24/32)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always       -       3
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       3
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       298
194 Temperature_Celsius     0x0022   032   049   000    Old_age   Always       -       32 (0 17 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       77 (93 159 0)
241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       2899409178
242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       12923505
254 Free_Fall_Sensor        0x0032   100   100   000    Old_age   Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.
```

So far so good. No obvious issues at least:

```bash
SMART overall-health self-assessment test result: PASSED
```

Let's try triggering a self-check:

```bash
# ~ 1 minute
sudo smartctl --test=short /dev/sda -d sat
# ~ 334 minutes
sudo smartctl --test=long /dev/sda -d sat
```

To get the test results, run `sudo smartctl --all /dev/sda -d sat` again after 1++ minute, and look for:

```bash
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%       402         -
# 2  Extended offline    Aborted by host               90%       402         -
```

I did not let the extended test complete, but the "short" test didn't reveal any issues.

So it looks like my hard disk is not failing after all. That's good news - If you're not as fortunate and do find issues, I urge you to un-mount and remove the drive immediately, until you have a replacement disk, to which you can _try_ to backup the failing disk.

Always ensure that you have minimum 2, if not 3 copies of your important data. For ex.:
- 1st copy on your computer
- 2nd copy on your backup hard disk
- 3rd copy, on a backup, of the backup which you don't keep in your house

Do not use cloud backup until absolutely necessary. It's encrypted today, but might easily be decrypted tomorrow.