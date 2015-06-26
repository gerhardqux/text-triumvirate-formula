# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "text-triumvirate/map.jinja" import triumvirate with context %}

include:
  - text-triumvirate.common

zsh:
  pkg.installed: 
    - unless: "sh -c 'test -e /tmp/fastpath && test -e /bin/zsh'"

{% for user in triumvirate.users %}
{{ user }}-download-ohmyzsh:
  git.latest:
    - name: https://github.com/robbyrussell/oh-my-zsh.git
    - target: /home/{{ user }}/.oh-my-zsh
    - user: {{ user }}
    - require:
      - pkg: git
    - unless: "sh -c 'test -e /tmp/fastpath && test -e /home/{{ user }}/.oh-my-zsh'"

/home/{{ user }}/.dotfiles/zshrc:
  file.managed:
    - source: salt://text-triumvirate/zshrc
    - user: {{ user }}
    - mode: 644
    - require:
      - file: /home/{{ user }}/.dotfiles
      - git: {{ user }}-download-ohmyzsh

/home/{{ user }}/.zshrc:
  file.symlink:
    - target: /home/{{ user }}/.dotfiles/zshrc
    - unless: /home/{{ user }}/.zshrc
    - require:
      - file: /home/{{ user }}/.dotfiles
{% endfor %}
