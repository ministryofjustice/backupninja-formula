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
system for full and incremental backups to a variety of target systems, using
GnuPG for encryption.

It does however suffer from a reasonably complicated command line, so this
formula also adds a helper 'duplicity_daily_helper' which talks to the target
of the daily backup (90.dup) configured in backupninja.

If hourly backups are enabled, then another helper 'duplicity_hourly_helper' is
also installed.

The duplicity helpers are present to simplify the listing and recovering of
files in the remote backup store.

