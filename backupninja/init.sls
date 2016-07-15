{% from 'backupninja/map.jinja' import backupninja with context %}

include:
  - .deps

backupninja:
  pkg:
    - installed

/etc/backupninja.conf:
  file:
    - managed
    - source: salt://backupninja/templates/backupninja.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: backupninja

/etc/logrotate.d/backupninja:
  file:
    - managed
    - source: salt://backupninja/templates/backupninja.logrotate.d
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: backupninja

/etc/cron.d/backupninja:
  file:
    - managed
    - source: salt://backupninja/templates/backupninja.cron.d
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: backupninja

/usr/share/backupninja/pgsql:
  file:
    - managed
    - source: salt://backupninja/files/pgsql
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: backupninja

/usr/share/backupninja/pgsql.helper:
  file:
    - managed
    - source: salt://backupninja/files/pgsql.helper
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: backupninja

/usr/share/backupninja/mongodb:
  file:
    - managed
    - source: salt://backupninja/files/mongodb
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: backupninja

/usr/share/backupninja/mongodb.helper:
  file:
    - managed
    - source: salt://backupninja/files/mongodb.helper
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: backupninja

/etc/backup.d:
  file:
    - directory
    - clean: True
    - user: root
    - group: root
    - mode: 770
    - require:
      - pkg: backupninja

# Because of the require_in we can't turn off this state via
# exclude, so adding a pillar to turn it off
/etc/backup.d/10.sys:
{% if backupninja.disable_default_backup_states %}
  file:
    - absent
{% else %}
  file:
    - managed
    - source: salt://backupninja/templates/backup.d/10.sys
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - makedirs: True
    - require_in:
      - file: /etc/backup.d
{% endif %}

{% if backupninja.duplicity.hourly.enabled %}
/etc/backup.d/80.dup:
  file:
    - managed
    - source: salt://backupninja/templates/backup.d/80.dup
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - makedirs: True
    - require_in:
      - file: /etc/backup.d
{% endif %}

{% if backupninja.duplicity.enabled %}
/etc/backup.d/90.dup:
{% if backupninja.disable_default_backup_states %}
  file:
    - absent
{% else %}
  file:
    - managed
    - source: salt://backupninja/templates/backup.d/90.dup
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - makedirs: True
    - require_in:
      - file: /etc/backup.d
{% endif %}
{% endif %}


{% if backupninja.duplicity.enabled %}
# .boto file, to aide command-line use of duplicity for
# recovery/inspection.
/root/.boto:
  file:
    - managed
    - source: salt://backupninja/templates/dot_boto
    - template: jinja
    - user: root
    - group: root
    - mode: 600

/usr/local/bin/duplicity_helper:
  file:
    - absent

/usr/local/etc/duplicity_helper.conf:
  file:
    - absent

/usr/local/bin/duplicity_daily_helper:
  file:
    - managed
    - source: salt://backupninja/files/duplicity_helper
    - user: root
    - group: root
    - mode: 0555

/usr/local/etc/duplicity_daily_helper.conf:
  file:
    - managed
    - source: salt://backupninja/templates/duplicity_daily_helper.conf
    - template: jinja
    - user: root
    - group: adm
    - mode: 440

{% if backupninja.duplicity.hourly.enabled %}
/usr/local/bin/duplicity_hourly_helper:
  file:
    - managed
    - source: salt://backupninja/files/duplicity_helper
    - user: root
    - group: root
    - mode: 0555

/usr/local/etc/duplicity_hourly_helper.conf:
  file:
    - managed
    - source: salt://backupninja/templates/duplicity_hourly_helper.conf
    - template: jinja
    - user: root
    - group: adm
    - mode: 440

{% endif %}
{% endif %}

{{backupninja.backup_base_dir}}:
  file:
    - directory
    - user: root
    - group: root
    - mode: 0755
    - require:
      - pkg: backupninja

{{backupninja.backup_base_dir}}/sys:
{% if backupninja.disable_default_backup_states %}
  file:
    - absent
{% else %}
  file:
    - directory
    - user: root
    - group: root
    - mode: 0750
{% endif %}

# Add iam friendly duplicity files
/usr/share/backupninja/dup-iam:
  file:
    - managed
    - source: salt://backupninja/files/dup-iam
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: backupninja

/usr/share/backupninja/dup-iam.helper:
  file:
    - managed
    - source: salt://backupninja/files/dup-iam.helper
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: backupninja
