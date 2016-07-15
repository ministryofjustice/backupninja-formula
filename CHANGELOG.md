## Unreleased

* Allow to disable the default backup states (10.sys and 90.dup) via pillar
* Make formula more IAM friendly

## Version 0.4.0

* Customize pgsql backup script to be able backup a remote DB server

## Version 0.3.1

* Fix to prevent /etc/backup.d cleaning from causing recreate of files within

## Version 0.3.0

* Reduce default retention of hourly backups.
* Make retentions overridable via pillar data
* Improve recovery/helper documentation

## Version 0.2.0

* helper files to make duplicity recovery easier

## Version 0.1.0

* General purpose backupninja formula
* optional backupninja backup to S3, encrypted, via duplicity
* includes 'sys' helper to back up key system info
