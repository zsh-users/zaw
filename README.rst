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

press ``^X;``,

1. select `source` and press ``enter``.
2. filter items with zsh patterns separated by spaces, use ``^N``, ``^P`` and select one.
3. execute action by pressing enter key or press Meta + enter for alternative action.

   instead, press tab key and select action you want to execute.


sources
=======

currently these sources are available:

  - ack
  - applications
  - bookmark
  - git-files
  - history
  - open-file
  - perldoc
  - screens


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
  git-files        zaw-git-files
  history          zaw-history
  open-file        zaw-open-file
  perldoc          zaw-perldoc
  screens          zaw-screens


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
  ':filter-select:highlight' title
  ':filter-select' max-lines
  ':filter-select' case-insensitive
  ':filter-select' extended-search

  example:
    zstyle ':filter-select:highlight' matched fg=yellow,standout
    zstyle ':filter-select' max-lines 10 # use 10 lines for filter-select
    zstyle ':filter-select' max-lines -10 # use $LINES - 10 for filter-select
    zstyle ':filter-select' case-insensitive yes # enable case-insensitive search
    zstyle ':filter-select' extended-search yes # see below

  extended-search:
      If this style set to be true value, the searching bahavior will be
      extended as follows:
  
      ^ Match the beginning of the line if the word begins with ^
      $ Match the end of the line if the word ends with $
      ! Match anything except the word following it if the word begins with !
      so-called smartcase searching
  
      If you want to search these metacharacters, please doubly escape them.

license
=======

BSD-3
