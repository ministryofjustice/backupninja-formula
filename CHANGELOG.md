CURRENT
-------

* Provide option to prevent mongo backups running on primary node

0.3.1
-----

* Fix to prevent /etc/backup.d cleaning from causing recreate of files within

0.3.0
-----

* Reduce default retention of hourly backups.
* Make retentions overridable via pillar data
* Improve recovery/helper documentation

0.2.0
-----

* helper files to make duplicity recovery easier

0.1.1
-----

* General purpose backupninja formula
* optional backupninja backup to S3, encrypted, via duplicity
* includes 'sys' helper to back up key system info
