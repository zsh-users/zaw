#
# zaw-src-ssh-hosts
#
# Note: .ssh/config must have "HashKnownHosts no" (default) to make known hosts
# values work.

function zaw-src-ssh-hosts(){
  local -a _global_ssh_known_hosts _global_ssh_known_hosts2 _ssh_known_hosts _ssh_known_hosts2 _etc_hosts _ssh_config_hosts
  [ -r /etc/ssh/ssh_known_hosts ] && _global_ssh_known_hosts=(${${${(f)"$(< /etc/ssh/ssh_known_hosts)"}%%\ *}%%,*}) 2>/dev/null || _global_ssh_known_hosts=()
  [ -r /etc/ssh/ssh_known_hosts2 ] && _global_ssh_known_hosts2=(${${${(f)"$(< /etc/ssh/ssh_known_hosts2)"}%%\ *}%%,*}) 2>/dev/null || _global_ssh_known_hosts2=()
  [ -r "$HOME/.ssh/known_hosts" ] && _ssh_known_hosts=(${${${(f)"$(< ~/.ssh/known_hosts)"}%%\ *}%%,*}) 2>/dev/null || _ssh_known_hosts=()
  [ -r "$HOME/.ssh/known_hosts2" ] && _ssh_known_hosts=(${${${(f)"$(< ~/.ssh/known_hosts2)"}%%\ *}%%,*}) 2>/dev/null || _ssh_known_hosts2=()
  [ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
  [ -r "$HOME/.ssh/config" ] && _ssh_config_hosts=(${${${(@M)${(f)"$(< ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*}) || _ssh_config_hosts=()
  candidates=(
    $_global_ssh_known_hosts[@]
    $_global_ssh_known_hosts2[@]
    $_ssh_known_hosts[@]
    $_ssh_known_hosts2[@]
    $_etc_hosts[@]
    $_ssh_config_hosts[@]
    "$HOST"
    ::1
    localhost
    127.0.0.1
  )
  candidates=(${(iou)candidates[@]})

  actions=("zaw-callback-ssh-connect" "zaw-callback-append-to-buffer" )

  act_descriptions=("ssh to the host" "append to edit buffer")
}

zaw-register-src -n ssh-hosts zaw-src-ssh-hosts

function zaw-callback-ssh-connect(){
  local orig_buffer="${BUFFER}"
  BUFFER="ssh $1"
  zle accept-line
}
