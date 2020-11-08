---
---

For running some binaries which were not compiled on PantherX or GNU Guix, probably you'll faced with the following error:

```
-bash: ./path/to/foreign/binary: No such file or directory
```

Thesolution is set the correct interpreter path with `patchelf` tools:

```bash
patchelf --set-interpreter "$(patchelf --print-interpreter "$(realpath "$(which sh)")")" /path/to/foreign/binary
```


### Steps

```bash
# 1. setting the correct interpreter path
$ patchelf --set-interpreter "$(patchelf --print-interpreter "$(realpath "$(which sh)")")" /path/to/foreign/binary

# 2. running the `ldd` for binary file and checking the availablity of libraries.
$ ldd /path/to/foriegn/binary

# 3. installing the libraries 
$ guix package -i ...

# 4. running
/path/to/foriegn/binary
```

### Example: ActivityWatch

```bash
# 1. Download/Extract the archive
$ wget https://github.com/ActivityWatch/activitywatch/releases/download/v0.9.2/activitywatch-v0.9.2-linux-x86_64.zip
$ unzip activitywatch-v0.9.2-linux-x86_64.zip

# 2. Running and issue
$ ./activitywatch/aw-qt 
bash: ./activitywatch/aw-qt: No such file or directory

# 3. Checking the interpreter path - in this example the interpreter path = /lib64/ld-linux-x86-64.so.2. This path is incorrect.
$ file ./activitywatch/aw-qt
./activitywatch/aw-qt: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=28ba79c778f7402713aec6af319ee0fbaf3a8014, stripped


# 4. Setting the correct interpreter path
$ patchelf --set-interpreter "$(patchelf --print-interpreter "$(realpath "$(which sh)")")" activitywatch/aw-qt
$ patchelf --set-interpreter "$(patchelf --print-interpreter "$(realpath "$(which sh)")")" activitywatch/aw-server/aw-server  
$ patchelf --set-interpreter "$(patchelf --print-interpreter "$(realpath "$(which sh)")")" activitywatch/aw-watcher-afk/aw-watcher-afk 
$ patchelf --set-interpreter "$(patchelf --print-interpreter "$(realpath "$(which sh)")")" activitywatch/aw-watcher-window/aw-watcher-window

# 5. running the `ldd` for binary file and checking the availablity of libraries.
$ ldd ./activitywatch/aw-qt
        linux-vdso.so.1 (0x00007ffcb4d93000)
        libdl.so.2 => /home/panther/.guix-profile/lib/libdl.so.2 (0x00007f2f2cc6a000)
        libz.so.1 => /home/panther/.guix-profile/lib/libz.so.1 (0x00007f2f2cc4a000)
        libc.so.6 => /home/panther/.guix-profile/lib/libc.so.6 (0x00007f2f2ca90000)
        /lib64/ld-linux-x86-64.so.2 => /gnu/store/ahqgl4h89xqj695lgqvsaf6zh2nhy4pj-glibc-2.29/lib/ld-linux-x86-64.so.2 (0x00007f2f2cc71000)
        libgcc_s.so.1 => /gnu/store/2plcy91lypnbbysb18ymnhaw3zwk8pg1-gcc-7.4.0-lib/lib/libgcc_s.so.1 (0x00007f2f2ca77000)

# 6. running
$ ./activitywatch/aw-qt 
2020-06-05 14:49:27 [INFO ]: Starting module aw-server  (aw_qt.manager:49)
2020-06-05 14:49:27 [INFO ]: Starting module aw-watcher-afk  (aw_qt.manager:49)
2020-06-05 14:49:27 [INFO ]: Starting module aw-watcher-window  (aw_qt.manager:49)
2020-06-05 14:49:27 [INFO ]: Creating trayicon...  (aw_qt.trayicon:140)
xkbcommon: ERROR: failed to add default include path /usr/share/X11/xkb
Qt: Failed to create XKB context!
Use QT_XKB_CONFIG_ROOT environmental variable to provide an additional search path, add ':' as separator to provide several search paths and/or make sure that XKB configuration data directory contains recent enough contents, to update please see http://cgit.freedesktop.org/xkeyboard-config/ .
2020-06-05 14:49:28 [INFO ]: aw-watcher-window started  (aw_watcher_window.main:40)
2020-06-05 14:49:28 [INFO ]: aw-watcher-afk started  (aw_watcher_afk.afk:53)
WARNING:root:Could not import pymongo, not available as a datastore backend
2020-06-05 14:49:29 [INFO ]: Using storage method: peewee  (aw_server.main:26)
2020-06-05 14:49:29 [INFO ]: Starting up...  (aw_server.main:31)
2020-06-05 14:49:29 [INFO ]: Using database file: /home/panther/.local/share/activitywatch/aw-server/peewee-sqlite.v2.db  (aw_datastore.storages.peewee:90)
 * Serving Flask app "aw-server" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
2020-06-05 14:49:29 [INFO ]:  * Running on http://localhost:5600/ (Press CTRL+C to quit)  (werkzeug:122)
2020-06-05 14:49:29 [INFO ]: Connection to aw-server established by aw-watcher-window  (aw_client.client:348)
2020-06-05 14:49:29 [INFO ]: Connection to aw-server established by aw-watcher-afk  (aw_client.client:348)
...
``` 

__Note:__   

Maybe another solution is exporting the `LD_LIBRARY_PATH` to pointing to `LIBRARY_PATH`:

```bash
export LD_LIBRARY_PATH=$LIBRARY_PATH
/path/to/foreign/binary
```

### Reference:
https://lists.gnu.org/archive/html/help-guix/2018-04/msg00141.html


