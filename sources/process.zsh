# zaw source for processes

function zaw-src-process () {
    local process_list="$(ps -U $USER ux | sed -e '1d' -e '/ps -U/d')"
    local process_desc="$(ps -U $USER ux | head -1)"
    local pid_list="$(echo $process_list | awk '{print $2}')"
    : ${(A)candidates::=${(f)pid_list}}
    : ${(A)cand_descriptions::=${(f)process_list}}
    actions=(zaw-callback-append-to-buffer zaw-src-process-kill)
    act_descriptions=("insert" "kill")
    options=(-t "$process_desc")
}

function zaw-src-process-kill () {
    BUFFER="kill $1"
    zle accept-line
}

zaw-register-src -n process zaw-src-process
