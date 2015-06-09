backupninja_repo_deps:
  pkgrepo.managed:
    - humanname: Duplicity PPA
    - name: deb http://ppa.launchpad.net/duplicity-team/ppa/ubuntu trusty main
    - dist: trusty
    - file: /etc/apt/sources.list.d/duplicity.list
    - keyid: 7A86F4A2
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: backupninja_deps


backupninja_deps:
  pkg.installed:
    - pkgs:
      - duplicity
{% if salt['grains.get']('osfinger') == 'Ubuntu-12.04' %}
      - hwinfo
      - python-paramiko   # prevent duplicity warnings
      - python-gobject-2  # prevent duplicity warnings
{% endif %}
