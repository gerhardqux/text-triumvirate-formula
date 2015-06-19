# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "text-triumvirate/map.jinja" import triumvirate with context %}

include:
  - text-triumvirate.common

vimpkg:
  pkg.installed: 
    - name: {{ triumvirate.vimpkg }}
    - unless: "sh -c 'test -e /tmp/fastpath && test -e /usr/bin/vim'"

{% for user in triumvirate.users %}
/home/{{ user }}/.dotfiles/vimrc:
  file.managed:
    - user: {{ user }}
    - source: salt://text-triumvirate/vimrc
    - mode: 644
    - require:
      - file: /home/{{ user }}/.dotfiles

/home/{{ user }}/.vimrc:
  file.symlink:
    - target: /home/{{ user }}/.dotfiles/vimrc
    - unless: test -e /home/{{ user }}/.vimrc
    - require:
      - user: user-{{ user }}-exists

vimdirs-{{ user }}:
  file.directory:
    - names:
      - /home/{{ user }}/.vim/plugin
      - /home/{{ user }}/.vim/bundle
      - /home/{{ user }}/.vim/autoload
      - /home/{{ user }}/.vim/colors
    - user: {{ user }}
    - mode: 755
    - makedirs: True
    - require:
      - user: user-{{ user }}-exists

install-pathogen-{{ user }}:
  cmd.run:
    - creates: /home/{{ user }}/.vim/autoload/pathogen.vim
    - name: curl -LSso /home/{{ user }}/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    - require:
      - file: vimdirs-{{ user }}

{% for script, url in triumvirate.vim.bundles.iteritems() %}
vim-script-{{ script }}-{{ user }}: 
  git.latest:
    - name: {{ url }}
    - target: /home/{{ user }}/.vim/bundle/{{ script }}
    - user: {{ user }}
    - require:
      - file: vimdirs-{{ user }}
      - pkg: git
    - unless: test -e /tmp/fastpath -a -e /home/{{ user }}/.vim/bundle/{{ script }}
{% endfor %}

{% endfor %}
