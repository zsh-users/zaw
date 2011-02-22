==============================
zaw - zsh anything like widget
==============================

install
=======

::

  $ git clone git://github.com/nakamuray/zaw.git
  remote: Counting objects: 136, done.
  remote: Compressing objects: 100% (86/86), done.
  remote: Total 136 (delta 43), reused 136 (delta 43)
  Receiving objects: 100% (136/136), 23.68 KiB, done.
  Resolving deltas: 100% (43/43), done.
  $ echo "source ${PWD}/zaw/zaw.zsh" >> ~/.zshrc

and restart zsh or manualy source ``zaw.zsh``.


usage
=====

press ``^X^Z``,

1. select `source`.
2. filter items with zsh pattern, use ``^N``, ``^P`` and select one.
3. execute action by pressing enter key or press Meta + enter for alternative action.

   instead, press tab key and select action you want to execute.


sources
=======

currently these sources are available:

  - history
  - perldoc


helper widgets
==============

zaw automaticaly create helper widgets for each sources
that directly access to the source.

for example, execute ``bindkey '^R' zaw-history`` and
press ``^R`` to access history source.


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
  ':filter-select' max-lines

  example:
    zstyle ':filter-select:highlight' matched fg=yellow,standout
    zstyle ':filter-select' max-lines 10 # use 10 lines for filter-select
    zstyle ':filter-select' max-lines -10 # use $LINES - 10 for filter-select
