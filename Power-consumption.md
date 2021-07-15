---
namespace: diff
description:
categories:
  - type:
      - "Guide"
  - location:
      - "General"
language: en
---

If you spend any time with a laptop, battery life is likely very important to you. With these tricks, you can literally double, or triple your average battery life.

By default your Desktop system comes with the following tweaks:

- `thermald` [information](https://01.org/linux-thermal-daemon/documentation/introduction-thermal-daemon)
- `TLP` [information](https://linrunner.de/tlp/)

## Measuing

### powerstat

This is an intersting tool that estimates your average energy consumption.

```bash
$ su - root # login as root
$ guix package -i powerstat
$ powerstat
Running for 300.0 seconds (30 samples at 10.0 second intervals).
Power measurements will start in 180 seconds time.

  Time    User  Nice   Sys  Idle    IO  Run Ctxt/s  IRQ/s Fork Exec Exit  Watts
17:45:57   3.7   0.0   1.0  95.1   0.2    1  18216   6425    9    7    8  14.02
17:46:07   8.9   0.0   0.8  90.0   0.3    1  17249   6867    8    8    5  13.65
17:46:17   3.7   0.0   1.0  95.1   0.2    2  19971   8947    6    7   12  13.95
17:46:27  13.0   0.0   0.9  85.9   0.2    3  17156   7230    3    6    6  14.54
17:46:37   9.5   0.0   0.9  89.1   0.5    1  19168   4085    7    8    8  15.65
17:46:47   4.1   0.0   0.8  94.9   0.2    2  14095   3602    5    7    6  15.63
17:46:57   4.6   0.0   1.3  94.0   0.2    1  18573   8782    7    6    4  14.94
17:47:07   8.1   0.0   1.1  90.4   0.4    1  14500   8270   13    8    6  15.08
17:47:17   5.6   0.0   1.0  93.2   0.3    1  19143   7395    5    7    5  15.35
17:47:27   5.8   0.0   0.8  93.2   0.2    1  15271   3717    4    6    3  14.88
17:47:37   5.2   0.0   0.9  93.5   0.4    6  18725   6805   22    8   14  14.98
17:47:47   1.8   0.0   0.7  97.1   0.3    1  13808   3267   13    7    7  14.78
17:47:57   1.8   0.0   1.0  97.0   0.2    1  18166   4832    9   10    9  13.93
17:48:07   2.0   0.0   0.9  97.0   0.1    1  13143   6813    8    8    6  13.18
17:48:17   4.4   0.0   1.0  93.9   0.7    1  16119   6932   11   12   34  13.23
17:48:27   8.5   0.0   1.0  90.2   0.3    1  17015   7758    5    7    9  13.68
17:48:37   3.3   0.0   1.0  95.4   0.2    1  16180   9186    6    9   10  13.59
17:48:47   5.5   0.0   1.2  93.0   0.3    1  19923   9726   20   17   17  13.61
17:48:57   2.7   0.0   0.9  96.2   0.2    2  16002   8392    7    6    7  14.03
17:49:07   8.5   0.0   1.6  89.4   0.4    2  19268   7476   42   27   25  14.60
17:49:17   2.0   0.0   1.0  96.2   0.7    1  18003   9764    4    6   15  14.06
17:49:27   5.2   0.0   1.7  93.1   0.0    2  18819   7888  482  292  477  13.81
17:49:37   4.0   0.0   1.1  93.9   1.0    1  15862  10252   35   19   56  14.34
17:49:47   7.1   0.0   1.1  91.3   0.5    1  20367  10639    5    6    9  14.38
17:49:57   3.9   0.0   1.2  94.8   0.2    8  21489   9459    6    6    5  15.04
17:50:07   2.7   0.0   1.0  96.0   0.2    4  16335   6346   27    8    8  14.37
17:50:17   3.0   0.0   1.1  95.3   0.6    1  21020   8836   10    7    8  14.20
17:50:27   2.1   0.0   1.0  96.6   0.3    1  15320   9200   28   23   28  14.13
17:50:37   5.4   0.0   1.2  93.0   0.3    1  21896   9497   19   17   30  13.57
17:50:47   3.5   0.0   0.9  95.3   0.3    1  14920   7175   12    8   10  13.90
-------- ----- ----- ----- ----- ----- ---- ------ ------ ---- ---- ---- ------
 Average   5.0   0.0   1.0  93.6   0.3  1.7 17524.0 7518.7 27.9 19.1 28.2  14.30
 GeoMean   4.4   0.0   1.0  93.6   0.0  1.4 17367.8 7196.2 10.8  9.8 11.1  14.29
  StdDev   2.7   0.0   0.2   2.7   0.2  1.6 2323.5 1989.5 84.9 51.0 84.1   0.66
-------- ----- ----- ----- ----- ----- ---- ------ ------ ---- ---- ---- ------
 Minimum   1.8   0.0   0.7  85.9   0.0  1.0 13142.6 3267.1  3.0  6.0  3.0  13.18
 Maximum  13.0   0.0   1.7  97.1   1.0  8.0 21896.5 10638.7 482.0 292.0 477.0  15.65
-------- ----- ----- ----- ----- ----- ---- ------ ------ ---- ---- ---- ------
Summary:
System:  14.30 Watts on average with standard deviation 0.66
```

## Tools

### Throttled

Using throttled, you can additionally reduce the power consumption by adjusting CPU and GPU voltage. This should be used with caution!

- [repository](https://github.com/erpalma/throttled) <- read this first!
- [config template](https://raw.githubusercontent.com/erpalma/throttled/master/etc/lenovo_fix.conf) for `/etc/throttled/config.conf`

You will need to adjust the config to suit your needs. Here's what works **for me** (i7-8565U)... Results vary greatly!:

```conf
[UNDERVOLT.BATTERY]
# CPU core voltage offset (mV)
CORE: -90
# Integrated GPU voltage offset (mV)
GPU: -65
# CPU cache voltage offset (mV)
CACHE: -90
# System Agent voltage offset (mV)
UNCORE: -65
# Analog I/O voltage offset (mV)
ANALOGIO: 0
```

Install and run:

```bash
$ su - root
$ guix package -i throttled
$ throttled --config /etc/throttled/config.conf
```

Right now there's no service yet, so you'll have to run `su - root; throttled --config /etc/throttled/config.conf` manually on each startup. It should be easy enough to prepare one though ...

Just for the curious, here are some readings from `powerstat` with `throttled` running:

```
  Time    User  Nice   Sys  Idle    IO  Run Ctxt/s  IRQ/s Fork Exec Exit  Watts
18:12:20   2.5   0.0   1.1  95.8   0.6    1  15237   4867    7    6   12  11.95
18:12:30   2.0   0.0   1.0  96.5   0.4    2  14098   4816   11   12   11  11.63
18:12:40   2.6   0.0   1.1  95.9   0.5    1  15202   3237   22    8    8  11.49
18:12:50   3.5   0.0   1.2  95.2   0.2    1  20642   5714    8    6    6  11.61
18:13:00   2.3   0.0   1.1  95.6   1.0    1  16946   6556    5    6    7  11.46
```

### cpupower

For more agressive power savings, I've found this tool the be useful.

```
su - root
guix package -i cpupower
cpupower frequency-set -g powersave
```

Again some readings from `powerstat` with `throttled` running, after cpupower adjustments:

```
  Time    User  Nice   Sys  Idle    IO  Run Ctxt/s  IRQ/s Fork Exec Exit  Watts
18:32:41   4.1   0.1   2.0  93.3   0.6    1   9997   6825   37   27   28   7.45
18:32:51  16.3   0.0   3.2  73.1   7.3    1  24108  10618  179   52   94   9.14
18:33:01   7.9   0.1   2.4  89.4   0.2    1  15276   8806   18   18   17   8.89
18:33:11   9.2   0.1   2.1  88.5   0.2    1  11546   3990    6    6    8   9.04
18:33:21   6.6   0.0   2.4  90.9   0.1    1  10996   3116    6    8   21   8.79
```

Together these tools to provide me with a substantial boost in runtime.
