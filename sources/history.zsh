zmodload zsh/parameter

function zaw-src-history() {
    cands_assoc=("${(@kv)history}")
    actions=("zaw-callback-history-execute" "zaw-callback-history-replace" "zaw-callback-history-append")
    act_descriptions=("execute" "replace edit buffer" "append to edit buffer")
    options="-r"
}

zle -N zaw-source-history

zaw-register-src -n history zaw-src-history


function zaw-callback-history-execute() {
    BUFFER="$1"
    zle accept-line
}

zle -N zaw-callback-history-execute


function zaw-callback-history-replace() {
    LBUFFER="$1"
    RBUFFER=""
}

zle -N zaw-callback-history-replace


function zaw-callback-history-append() {
    LBUFFER="${BUFFER}$1"
}

zle -N zaw-callback-history-append
