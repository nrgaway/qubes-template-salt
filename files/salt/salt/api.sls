##
# Install salt-api
##

#include:
#  - salt.master

salt-api:
  service.running:
    - name: salt-api
    - enable: True
    - watch:
      - file: /etc/systemd/system/salt-api.service

# salt-api unit file
/etc/systemd/system/salt-api.service:
  file.managed:
    - source: salt://salt/files/salt-api.service
    - user: root
    - group: root
    - mode: 755
