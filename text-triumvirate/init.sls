gerhard:
  user.present

git:
  pkg.installed: 
    - unless: "sh -c 'test -e /tmp/fastpath && test -e /usr/bin/git'"

zsh:
  pkg.installed: 
    - unless: "sh -c 'test -e /tmp/fastpath && test -e /bin/zsh'"

vimpkg:
  pkg.installed: 
    {% if grains['os_family'] == 'RedHat' %}
    - name: vim-enhanced
    {% elif grains['os_family'] == 'Debian' %}
    - name: vim
    {% endif %}
    - unless: "sh -c 'test -e /tmp/fastpath && test -e /usr/bin/vim'"

tmux:
  pkg.installed: 
    - unless: "sh -c 'test -e /tmp/fastpath && test -e /usr/bin/tmux'"

gerhard-ohmyzsh:
  file.directory:
    - name: /home/gerhard/.oh-my-zsh
    - user: gerhard
    - group: gerhard
    - mode: 755
    - mkdirs: True

download-ohmyzsh:
  git.latest:
    - name: https://github.com/robbyrussell/oh-my-zsh.git
    - target: /home/gerhard/.oh-my-zsh
    - user: gerhard
    - require:
      - file: /home/gerhard/.oh-my-zsh
      - pkg: git
    - unless: "sh -c 'test -e /tmp/fastpath && test -e /home/gerhard/.oh-my-zsh'"

/home/gerhard/.dotfiles:
  file.directory:
    - user: gerhard
    - group: gerhard
    - mode: 755
    - mkdirs: True

/home/gerhard/.dotfiles/zshrc:
  file.managed:
    - source: salt://text-triumvirate/zshrc
    - user: gerhard
    - group: gerhard
    - mode: 644
    - require:
      - file: /home/gerhard/.dotfiles
      - git: download-ohmyzsh

/home/gerhard/.zshrc:
  file.symlink:
    - target: /home/gerhard/.dotfiles/zshrc
    - force: True

/home/gerhard/.dotfiles/vimrc:
  file.managed:
    - user: gerhard
    - source: salt://text-triumvirate/vimrc
    - mode: 644
    - require:
      - file: /home/gerhard/.dotfiles

/home/gerhard/.vimrc:
  file.symlink:
    - target: /home/gerhard/.dotfiles/vimrc
    - force: True

vimdir:
  file.directory:
    - name: /home/gerhard/.vim
    - user: gerhard
    - group: gerhard
    - mode: 755
    - mkdirs: True

vimdirs:
  file.directory:
    - names:
      - /home/gerhard/.vim/plugin
      - /home/gerhard/.vim/bundle
      - /home/gerhard/.vim/autoload
      - /home/gerhard/.vim/colors
    - user: gerhard
    - group: gerhard
    - mode: 755
    - mkdirs: True
  require:
    - file: vimdir

install-pathogen:
  cmd.run:
    - creates: /home/gerhard/.vim/autoload/pathogen.vim
    - name: curl -LSso /home/gerhard/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    - require:
      - file: vimdirs

{%

set scripts = {
  'align': 'https://github.com/vim-scripts/Align',
  'ctrlp.vim': 'https://github.com/kien/ctrlp.vim.git',
  'nerdtree': 'https://github.com/scrooloose/nerdtree.git',
  'salt-vim': 'https://github.com/saltstack/salt-vim',
  'syntastic': 'https://github.com/scrooloose/syntastic.git',
  'vim-powerline': 'https://github.com/Lokaltog/vim-powerline.git',
  'vim-gocode': 'https://github.com/Blackrush/vim-gocode.git',
  'vim-golang': 'https://github.com/jnwhiteh/vim-golang.git',
  'vim-colors-solarized': 'git://github.com/altercation/vim-colors-solarized.git',
}

%}

{% for script in scripts %}
vim-script-{{ script }}: 
  git.latest:
    - name: {{ scripts[script] }}
    - target: /home/gerhard/.vim/bundle/{{ script }}
    - user: gerhard
    - require:
      - file: vimdirs
      - pkg: git
    - unless: "sh -c 'test -e /tmp/fastpath && test -e /home/gerhard/.vim/bundle/{{ script }}'"
{% endfor %}

