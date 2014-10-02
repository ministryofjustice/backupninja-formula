backupninja_deps:
  pkg.installed:
    - pkgs:
      - hwinfo
      - duplicity
      - python-paramiko   # prevent duplicity warnings
      - python-gobject-2  # prevent duplicity warnings
