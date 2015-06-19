========================
text-triumvirate-formula
========================

A saltstack formula that, somewhat loosely, implements Dr. Bunsen's
text triumvirate of zsh, tmux and vim.

    In 62 BC, Caesar united a political alliance between himself, the statesman Crassus, and the military general Pompey. Together, the three men formed a secret political faction called the Triumvirate that ruled the Roman Republic. The Text Triumvirate is an alliance between the zsh, vim, and tmux. Each of these venerable tools is extremely powerful in its own right; however, together they are an unmatched productivity force that rules all forms of text manipulation.

See: <http://www.drbunsen.org/the-text-triumvirate/>`_.

The users listed in triumvirate.users in the pillar will be created if they do
not exist.  You should configure this with your own user before running these
states.

Dotfiles will be placed in $HOME/.dotfiles to prevent breaking a user's
configuration. In this case, take care to merge the .dotfiles into
your own dotfiles.

Available states
================

.. contents::
    :local:

``text-triumvirate``
--------------------

Installs the entire triumvirate of tmux, zsh, and vim.

``text-triumvirate.tmux``
-------------------------

Installs the tmux part of the triumvirate.

Tmux is a terminal multiplexer not unlike screen. It is configured
with vim key bindings.

``text-triumvirate.zsh``
------------------------

Installs the zsh part of the triumvirate.

Zsh is a popular shell. It too is configured with vim key bindings.
Also, the oh-my-zsh framework is installed.

``text-triumvirate.vim``
-------------------------

Installs the vim part of the triumvirate.

Vim is a programmers text editor. It is configured with pathogen
and several plugins that are configured through pillar.

