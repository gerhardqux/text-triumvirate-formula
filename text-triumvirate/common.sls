# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "text-triumvirate/map.jinja" import triumvirate with context %}

git:
  pkg.installed: 
    - unless: "sh -c 'test -e /tmp/fastpath && test -e /usr/bin/git'"

{% for user in triumvirate.users %}
user-{{ user }}-exists:
  user.present:
    - name: {{ user }}

/home/{{ user }}/.dotfiles:
  file.directory:
    - user: {{ user }}
    - mode: 755
    - makedirs: True
  require:
    - user: user-{{ user }}-exists
{% endfor %}
