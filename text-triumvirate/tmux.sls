# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "text-triumvirate/map.jinja" import triumvirate with context %}

tmux:
  pkg.installed: 
    - unless: "sh -c 'test -e /tmp/fastpath && test -e /usr/bin/tmux'"
