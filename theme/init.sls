#!yamlscript

##
# theme
##

$defaults: False
$pillars:
  auto: False

$python: |
    from salt://theme/map.sls import ThemeMap

$with theme-dependencies:
  pkg.installed:
    - names: 
      - freetype-freeworld 
      - gnome-tweak-tool 
      - dconf-editor 
      - xdg-user-dirs 
      - gnome-themes-standard 
      - xsettingsd

  gsettings set org.gnome.settings-daemon.plugins.xsettings hinting slight:
    cmd.run: 
      - onlyif: /bin/bash -c "[ $(gsettings get org.gnome.settings-daemon.plugins.xsettings hinting) != 'slight' ]"

  gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing rgba:
    cmd.run:
      - onlyif: /bin/bash -c "[ $(gsettings get org.gnome.settings-daemon.plugins.xsettings antialiasing) != 'rgba' ]"

  X11_configuration: 
    file.managed:
      - __id__: $ThemeMap.xdg_qubes_settings
      - source: salt://theme/files/25xdg-qubes-settings
      - user: root
      - group: root
      - mode: 644

  /etc/xdg/fonts.conf:
    file.managed:
      - source: salt://theme/files/fonts.conf
      - user: root
      - group: root
      - mode: 644

  /etc/xdg/Xresources:
    file.managed:
      - source: salt://theme/files/Xresources
      - user: root
      - group: root
      - mode: 644

  /etc/xdg/xsettingsd:
    file.managed:
      - source: salt://theme/files/xsettingsd
      - user: root
      - group: root
      - mode: 644
