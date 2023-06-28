---
namespace: postgresql
description: "PostgreSQL also known as Postgres, is a free and open-source relational database management system (RDBMS) emphasizing extensibility and SQL compliance."
description-source: "https://en.wikipedia.org/wiki/PostgreSQL"
categories:
  - type:
      - "Application"
  - location:
      - "Development"
language: en
---

## Upgrade PostgreSQL Database from 13.4 to 14.4

When you're trying to start a newer postgrsql version against an older data directory, you'll likely see an error like this:

```bash
$ herd start postgres
herd: exception caught while executing 'start' on service 'postgres':
Throw to key `%exception' with args `("#<&invoke-error program: \"/gnu/store/1mlqhrairx34kikvlykbivn8vs7xkx1a-pg_ctl-wrapper\" arguments: (\"start\") exit-status: 1 term-signal: #f stop-signal: #f>")'.
```

It's easy to upgrade the data directory, but the command looks intimidating at first:

```
pg_upgrade -b oldbindir [-B newbindir] -d oldconfigdir -D newconfigdir [option...]
```

Here's how-to go about this step by step:

First we need to figure out the path to the old and new postgreql binary:

```bash
$ ls /gnu/store | grep postgres
03rwm9cnlbvjdrz92kgvddqpx603shya-postgresql-13.4.tar.xz.drv
0hgwl6dkf8z4kx7gclx3fgl69pfy3hvc-postgresql-13.4.tar.xz-builder
1fcg01r57q28dlhhml4fvw92bsslw72i-postgresql.conf
2r94nax4c945hyprixxcpjg1xp3figgx-postgresql.conf
fs6ww3wa2mrskmrw55iy1b4jmqy73hy0-shepherd-postgres.go
hk2yrlvrva7824mfny51fi6b666man9p-shepherd-postgres.go
iw2m2dy84cqkc2409r32d4wxd05iqrvn-postgresql-13.4
l22nr3k2nxgcshna9196v7kgrvhzqjcd-postgresql-13.4.drv
nkswljw6b5ndc8jh6ylhdpx6sbn1slk6-shepherd-postgres.go
q6qp3521gay7izpz8p68d21zsdmz6nnm-postgresql-13.4
qgbw046wj648gdmgr7wl98k9mfx9mg6j-shepherd-postgres.scm
rq94z9yzd9x6p8vp3wybmja2kf9hk73h-postgresql-13.4
v1bdvlmsw5lwvjjzqi082hlsf1g5591j-shepherd-postgres.scm
xw5av8mqqsq7cc2lhhfb12l6lvblgr52-postgresql-14.4
xybby4jjnglmmkaj7pzfspfcyvh3npva-postgresql-13.4
yrrj1apg4fmyjv24lmna2pndikihpqal-shepherd-postgres.scm
z0l965an2i8pih8qpxaiwc22vfnh101b-postgresql-13.4.tar.bz2.drv
zh90n5bpg3mlj31r5fg967s4al9d9afv-postgresql-disable-resolve_symlinks.patch
znji0g0h11mn56pw15dv2vah8lzfi69w-postgresql-13.4-builder
-bash-5.1# ls /gnu/store | grep postgres-13.4
```

Find the `oldbindir`:

```bash
$ ls /gnu/store/xybby4jjnglmmkaj7pzfspfcyvh3npva-postgresql-13.4/bin
clusterdb   dropdb    initdb             pg_basebackup  pg_config       pg_dump     pg_receivewal   pg_restore  pg_test_fsync   pg_verifybackup  postmaster  vacuumdb
createdb    dropuser  oid2name           pgbench        pg_controldata  pg_dumpall  pg_recvlogical  pg_rewind   pg_test_timing  pg_waldump       psql        vacuumlo
createuser  ecpg      pg_archivecleanup  pg_checksums   pg_ctl          pg_isready  pg_resetwal     pg_standby  pg_upgrade      postgres         reindexdb
```

Find the `newbindir`:

```bash
$ ls /gnu/store/xw5av8mqqsq7cc2lhhfb12l6lvblgr52-postgresql-14.4/bin
clusterdb   dropdb    initdb      pg_archivecleanup  pg_checksums    pg_ctl      pg_isready      pg_resetwal  pg_test_fsync   pg_verifybackup  postmaster  vacuumdb
createdb    dropuser  oid2name    pg_basebackup      pg_config       pg_dump     pg_receivewal   pg_restore   pg_test_timing  pg_waldump       psql        vacuumlo
createuser  ecpg      pg_amcheck  pgbench            pg_controldata  pg_dumpall  pg_recvlogical  pg_rewind    pg_upgrade      postgres         reindexdb
```

Find the current config dir:

```bash
$ ls /var/lib/postgresql/data
base    pg_commit_ts  pg_hba.conf    pg_logical    pg_notify    pg_serial     pg_stat      pg_subtrans  pg_twophase  pg_wal   postgresql.auto.conf  postmaster.opts
global  pg_dynshmem   pg_ident.conf  pg_multixact  pg_replslot  pg_snapshots  pg_stat_tmp  pg_tblspc    PG_VERSION   pg_xact  postgresql.conf       postmaster.pid
```

We'll move the current dir from `/var/lib/postgresql/data` to `/var/lib/postgresql/old_data` and create a new, empty `/var/lib/postgresql/data`

```bash
mv /var/lib/postgresql/data /var/lib/postgresql/old_data
mkdir /var/lib/postgresql/data
chown -R postgres /var/lib/postgresql
```

Next we login as postgres user, to create the new DB

```bash
sudo -u postgres -s /bin/sh
```

Now you can create the new, placeholder DB:

```bash
initdb /var/lib/postgresql/data
```

Next, run the database migration:

```bash
# change to a /tmp dir to avoid: could not open log file "pg_upgrade_internal.log": Permission denied
cd /tmp
```

and then:

```bash
$ pg_upgrade \
-b /gnu/store/xybby4jjnglmmkaj7pzfspfcyvh3npva-postgresql-13.4/bin \
-B /gnu/store/xw5av8mqqsq7cc2lhhfb12l6lvblgr52-postgresql-14.4/bin \
-d /var/lib/postgresql/old_data \
-D /var/lib/postgresql/data

Performing Consistency Checks
-----------------------------
Checking cluster versions                                   ok
Checking database user is the install user                  ok
Checking database connection settings                       ok
Checking for prepared transactions                          ok
Checking for system-defined composite types in user tables  ok
Checking for reg* data types in user tables                 ok
Checking for contrib/isn with bigint-passing mismatch       ok
Checking for user-defined encoding conversions              ok
Checking for user-defined postfix operators                 ok
Creating dump of global objects                             ok
Creating dump of database schemas
                                                            ok
Checking for presence of required libraries                 ok
Checking database user is the install user                  ok
Checking for prepared transactions                          ok
Checking for new cluster tablespace directories             ok

If pg_upgrade fails after this point, you must re-initdb the
new cluster before continuing.

Performing Upgrade
------------------
Analyzing all rows in the new cluster                       ok
Freezing all rows in the new cluster                        ok
Deleting files from new pg_xact                             ok
Copying old pg_xact to new server                           ok
Setting oldest XID for new cluster                          ok
Setting next transaction ID and epoch for new cluster       ok
Deleting files from new pg_multixact/offsets                ok
Copying old pg_multixact/offsets to new server              ok
Deleting files from new pg_multixact/members                ok
Copying old pg_multixact/members to new server              ok
Setting next multixact ID and offset for new cluster        ok
Resetting WAL archives                                      ok
Setting frozenxid and minmxid counters in new cluster       ok
Restoring global objects in the new cluster                 ok
Restoring database schemas in the new cluster
                                                            ok
Copying user relation files
                                                            ok
Setting next OID for new cluster                            ok
Sync data directory to disk                                 ok
Creating script to delete old cluster                       ok
Checking for extension updates                              ok

Upgrade Complete
----------------
Optimizer statistics are not transferred by pg_upgrade.
Once you start the new server, consider running:
    /gnu/store/xw5av8mqqsq7cc2lhhfb12l6lvblgr52-postgresql-14.4/bin/vacuumdb --all --analyze-in-stages

Running this script will delete the old cluster's data files:
    ./delete_old_cluster.sh
```

Unless you want to keep the old files, delete them now:

```bash
./delete_old_cluster.sh
```

That's it.

Logout from `postgres` user and start the database server:

```bash
$ exit
$ herd start postgres
Service postgres has been started.
```