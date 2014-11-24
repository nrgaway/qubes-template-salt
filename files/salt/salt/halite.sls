#!yamlscript

##
# salt-halite
# -----------
# (Code-name) Halite is a Salt GUI. Status is pre-alpha. 
# Contributions are very welcome. Join us in #salt on Freenode or on the salt-users mailing list.
#
# TODO:  Start it; not sure how to do it yet without using cmd
##

$defaults: False
$pillars:
  auto: False

$python: |
    import os
    from salt://salt/map.sls import SaltMap
    from salt.utils.pyobjects import SaltObject

    salt = SaltObject(__salt__)

    # /etc/pki/minion/certs/localhost.*
    salt.tls.create_ca('minion')
    salt.tls.create_csr('minion')
    if not os.path.isfile('/etc/pki/minion/certs/localhost.crt'):
        salt.tls.create_ca_signed_cert('minion', 'localhost')

    # /etc/pki/tls/certs/localhost.*
    salt.tls.create_self_signed_cert()

    # Create a .pem file for web server
    filenames = ['/etc/pki/tls/certs/localhost.crt', '/etc/pki/tls/certs/localhost.key']
    with open('/etc/pki/tls/certs/localhost.pem', 'w') as outfile:
        for fname in filenames:
            with open(fname) as infile:
                outfile.write(infile.read())

# XXX: yamlscript bug; including a file already processed will give dup keys!
#include:
#  - salt.master

salt-halite-dependencies:
  pkg.installed:
    - names:
      - gcc
      - $SaltMap.python_dev
      - $SaltMap.libevent_dev

salt-halite-pip-dependencies:
  pip.installed:
    - names:
      - CherryPy 
      - gevent
    - require:
      - pip: salt-master
      - pkg: salt-halite-dependencies

# Install development version from git
salt-halite:
  pip.installed:
    - name: salt-halite 
    - editable: "git+https://github.com/saltstack/halite.git#egg=halite"
    #- no_deps: True # We satisfy deps already 
    - upgrade: True
    - require:
      - pip: salt-master
      - pip: salt-halite-pip-dependencies
      - pkg: git
  #service.running:
  #  - name: salt-halite
  #  #- name: halite
  #  - enable: False
  #  - require:
  #    - pip: salt-master
  #  - watch:
  #    - file: /etc/salt/master.d/halite.conf

# halite configuration file
/etc/salt/master.d/halite.conf:
  file.managed:
    - source: salt://salt/files/master.d/halite.conf
    - user: root
    - group: root
    - mode: 640
    - watch_in:
      - service: salt-master

