# zaw source for processes

function zaw-src-process () {
    local ps_list title ps pid_list
    ps_list="$(ps -ux --sort args)"
    title="${${(f)ps_list}[1]}"
    ps="$(echo $ps_list | sed '1d')"
    pid_list="$(echo $ps | awk '{print $2}')"
    : ${(A)candidates::=${(f)pid_list}}
    : ${(A)cand_descriptions::=${(f)ps}}
    actions=(zaw-callback-append-to-buffer zaw-src-process-kill)
    act_descriptions=("insert" "kill")
    options=(-t "$title")
}

function zaw-src-process-kill () {
    BUFFER="kill $1"
    zle accept-line
}

zaw-register-src -n process zaw-src-process
