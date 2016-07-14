=======
backupninja
=======

Formula to set up and configure 'backupninja' on a server.

Backupninja makes scheduling multiple different backup tools simple. There are
handlers for mysql, postgresql, duplicity, rdiff-backup, ...

There is no daemon process, it essentially hooks into cron.


duplicity
---------

The primary use-case for this formula (though optional) is to send
daily and potentially hourly encrypted backups to Amazon S3 using
the 'duplicity' backup/restore tool.

`Duplicity <http://http://duplicity.nongnu.org/>`_ is a very complete
system for full and incremental backups to a variety of remote systems, using
GnuPG for encryption and signing. This formula currently only supports symmetric
encryption, for ease of recovery and operational simplicity.

It does however suffer from a reasonably complicated command line, so this
formula also adds a helper 'duplicity_daily_helper' which talks to the target
of the daily backup (90.dup) configured in backupninja.

If hourly backups are enabled (via backupninja.duplicity.hourly.enabled),
then another helper 'duplicity_hourly_helper' is also installed.

The duplicity helpers are present to simplify the listing and recovering of
files in the remote backup store.

** It is important to ensure that the files backed up by the hourly backup are
also backed up by the daily backup set. The hourly backup has a shorter
retention period, so longer term recovery is only possible from the daily
set **

Default Backup Sets
---------

Out of the box, this formula will:

- Take a system info backup to /var/backups/sys
- Back up core directories to an S3 bucket named after the FQDN of the
  machine. See backupninja/map.jinja for the default list of included dirs.

The following pillars *must* be provided::

    backupninja.duplicity.password              # strong key to use for encryption
    backupninja.duplicity.s3bucket              # S3 bucket name
    backupninja.duplicity.awsaccesskeyid        # aws credentials
    backupninja.duplicity.awssecretaccesskeyid

If you don't like the default backup behaviour, and want to customise it fully,
you can set the following pillar to True, to disable the 10.sys and 90.dup states::

    backupninja.disable_default_backup_states: True

To enable the hourly backup set, you must set::

    backupninja.duplicity.hourly.enabled: True
    backupninja.duplicity.hourly.includes: []   # list of directories to include

Note that you *must* give the hourly backup a list of directories to back up.


Recovery of data using Duplicity helpers
---------

This formula provides 'helper wrappers' around duplicity, to simplify recovery.
These are purposefully made as short shell scripts, so it's easy to understand
what they are doing if more complex duplicity commands are required.

Each duplicity backup set ('daily' and optionally 'hourly') has its own
helper::

    /usr/local/bin/duplicity_daily_helper
    /usr/local/bin/duplicity_hourly_helper

These read in a config file that provides them the credentials needed to access
the remote backup store and decrypt the data.

Examples below are for the daily helper, but the same arguments and processes
apply to the hourly helper.

To list the files available in a backup set, do::

    $ duplicity_daily_helper files
    [stuff about syncing metadata]
    etc/.git/
    ...
    var/backups/sys/
    ...

This will, after syncronising a local cache of metadata, list all the files
backed up in that set.

To see available backup sets (hourly, in this instance), do::

    $ duplicity_hourly_helper sets
    [stuff about syncing metadata]
    Last full backup date: Wed Oct  8 11:00:05 2014
    [snip]
    Total number of contained volumes: 293
     Type of backup set:                            Time:   Number of volumes:
                     Full         Wed Oct  8 11:00:05 2014                 1
              Incremental         Wed Oct  8 12:00:05 2014                 1
              Incremental         Wed Oct  8 13:00:05 2014                 1
              Incremental         Wed Oct  8 14:00:05 2014                 1
              Incremental         Wed Oct  8 15:00:04 2014                 1
    [snip]


Most importantly, to recover a backup set::

    $ sudo duplicity_daily_helper restore {target_dir}

It is usually best to recover to a temp directory and then rsync
files into place. Running without sudo is possible, but duplicity will error about
not being able to set permissions and will not update mtimes - so it's
advisable to always use sudo for recovery.


Recovery of a particular point in time is possible by specifying the --time
option::

    $ sudo duplicity_daily_helper restore --time 6d {target_dir}

The example above will recover from the backup set taken 6 days ago. See
duplicity(1) for more information on the time formats it accepts.


backupninja and IAM policies
---------

Backupninja and its duplicity tend to require AWS keys, but this formula will
attempt to relax this requirement via introducing a new handler called dup-iam.
This should be used in the same fashion as the dup handler, and will no longer
error out if no AWS keys are specified, and will no longer export the AWS env
vars and thus will no longer misdirect boto. An indication that this might be
happening is the error message from duplicity eg::

    # duplicity_daily_helper files
    BackendException: No connection to backend

Note that you can still use duplicity_daily_helper with dup-iam.

