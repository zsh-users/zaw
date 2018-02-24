=================================
zaw - zsh anything.el-like widget
=================================

install
=======

::

  $ git clone git://github.com/zsh-users/zaw.git
  remote: Counting objects: 136, done.
  remote: Compressing objects: 100% (86/86), done.
  remote: Total 136 (delta 43), reused 136 (delta 43)
  Receiving objects: 100% (136/136), 23.68 KiB, done.
  Resolving deltas: 100% (43/43), done.
  $ echo "source ${PWD}/zaw/zaw.zsh" >> ~/.zshrc

and restart zsh or manualy source ``zaw.zsh``.


usage
=====

1. Trigger `zaw` by pressing ``Ctrl-x ;`` (``^x;``).
2. select `source` and press ``enter``.
3. filter items with zsh patterns separated by spaces, use ``^N``, ``^P`` and select one.
4. execute action by pressing enter key or press ``Meta-enter`` for alternative action.

   instead, press tab key and select action you want to execute.


sources
=======

currently these sources are available:

- aliases
- applications
- bookmark
- cdr (needs cdr enabled.  Google it or use `this packaged version <https://github.com/willghatch/zsh-cdr>`_)
- commands
- command-output
- fasd
- fasd-directories
- fasd-files
- functions
- git-branches
- git-recent-all-branches
- git-recent-branches
- git-files
- git-files-legacy
- git-log
- git-reflog
- git-status
- history
- locate
- open-file
- perldoc
- process
- programs
- screens
- searcher (ag/ack)
- ssh-hosts
- tmux
- widgets

(Note: git-files-legacy is an alternative for git-files.
git-files classifies modified files, git-files-legacy doesn't do it for
performance reason.)

Additional sources can be installed as third-party plugins.  Here is a list of all
the ones we know about.  Please let us know about any more you find or make!
Installation is easiest with a plugin manager such as 
`zgen <https://github.com/tarjoilija/zgen>`_.  Otherwise you can just source the
.zsh file that contains the source.

- calibre source: https://github.com/junkblocker/calibre-zaw-source
- MPD source: https://github.com/willghatch/zsh-zaw-mpd
- `pass <http://www.passwordstore.org>`_ source: https://gist.github.com/f440/9992963
- systemd source: https://github.com/termoshtt/zaw-systemd
- `todoman <https://github.com/hobarrera/todoman>`_ source: https://github.com/willghatch/zsh-zaw-todoman

shortcut widgets
================

zaw automaticaly create shortcut widgets for each sources
that directly access to the source.

for example, execute ``bindkey '^R' zaw-history`` and
press ``^R`` to access history source.

you can get all available shortcut widgets' name using ``zaw-print-src``::

  $ zaw-print-src
  source name      shortcut widget name
  ----------------------------------------
  ack              zaw-ack
  applications     zaw-applications
  bookmark         zaw-bookmark
  git-branches     zaw-git-branches
  git-recent-all-branches     zaw-git-recent-all-branches
  git-recent-branches     zaw-git-recent-branches
  git-files        zaw-git-files
  git-files-legacy zaw-git-files-legacy
  git-status       zaw-git-status
  history          zaw-history
  open-file        zaw-open-file
  perldoc          zaw-perldoc
  process          zaw-process
  screens          zaw-screens
  ssh-hosts        zaw-ssh-hosts
  tmux             zaw-tmux
  fasd             zaw-fasd
  fasd-directories zaw-directories
  fasd-files       zaw-files


key binds and styles
====================

zaw use ``filter-select`` to filter and select items.

you can use these key binds::

  enter:              accept-line (execute default action)
  meta + enter:       accept-search (execute alternative action)
  Tab:                select-action
  ^G:                 send-break
  ^H, backspace:      backward-delete-char
  ^F, right key:      forward-char
  ^B, left key:       backward-char
  ^A:                 beginning-of-line
  ^E:                 end-of-line
  ^W:                 backward-kill-word
  ^K:                 kill-line
  ^U:                 kill-whole-line
  ^N, down key:       down-line-or-history (select next item)
  ^P, up key:         up-line-or-history (select previous item)
  ^V, page up key:    forward-word (page down)
  ^[V, page down key: backward-word (page up)
  ^[<, home key:      beginning-of-history (select first item)
  ^[>, end key:       end-of-history (select last item)

and these zstyles to customize styles::

  ':filter-select:highlight' selected
  ':filter-select:highlight' matched
  ':filter-select:highlight' marked
  ':filter-select:highlight' title
  ':filter-select:highlight' error
  ':filter-select' max-lines
  ':filter-select' rotate-list
  ':filter-select' case-insensitive
  ':filter-select' extended-search
  ':filter-select' hist-find-no-dups
  ':filter-select' escape-descriptions
  ':zaw:<source-name>' default <func_name>
  ':zaw:<source-name>' alt <func_name>

  example:
    zstyle ':filter-select:highlight' matched fg=yellow,standout
    zstyle ':filter-select' max-lines 10 # use 10 lines for filter-select
    zstyle ':filter-select' max-lines -10 # use $LINES - 10 for filter-select
    zstyle ':filter-select' rotate-list yes # enable rotation for filter-select
    zstyle ':filter-select' case-insensitive yes # enable case-insensitive search
    zstyle ':filter-select' extended-search yes # see below
    zstyle ':filter-select' hist-find-no-dups yes # ignore duplicates in history source
    zstyle ':filter-select' escape-descriptions no # display literal newlines, not \n, etc
    zstyle ':zaw:git-files' default zaw-callback-append-to-buffer # set default action for git-files
    zstyle ':zaw:git-files' alt zaw-callback-edit-file # set the alt action for git-files

  extended-search:
      If this style set to be true value, the searching bahavior will be
      extended as follows:
  
      ^ Match the beginning of the line if the word begins with ^
      $ Match the end of the line if the word ends with $
      ! Match anything except the word following it if the word begins with !
      so-called smartcase searching
  
      If you want to search these metacharacters, please doubly escape them.

environment variable
====================

ZAW_EDITOR              editor command. If this variable is not set, use EDITOR value.
ZAW_EDITOR_JUMP_PARAM   open editor command with line params.
                        %LINE% is replaced by line number.
                        %FILE% is replaced by file path.
                        default +%LINE% %FILE%


making sources
==============

If you want to make another source, please do!  Look at https://github.com/termoshtt/zaw-systemd
as an example of how to make a source repo.  Note that it uses the <name>.plugin.zsh
convention that plugin managers like zgen and antigen expect for its main file.
The sources directory contains the files for the actual sources.  All the sources
in this repository's ``sources`` directory are good references as well for what
the source files should look like.  They tend to be quite simple.
If your source requires any additional configuration or dependencies, be sure to
list all of that in your project's README file.

Let us know when you make new plugins so we can add them to our list!

license
=======

BSD-3
