backupninja_deps:
  pkg.installed:
    - pkgs:
      - duplicity
{% if salt['grains.get']('osfinger') == 'Ubuntu-12.04' %}
      - hwinfo
      - python-paramiko   # prevent duplicity warnings
      - python-gobject-2  # prevent duplicity warnings
{% endif %}
