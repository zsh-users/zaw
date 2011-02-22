zmodload zsh/parameter

function zaw-src-history() {
    cands_assoc=("${(@kv)history}")
    actions=("zaw-callback-history-execute" "zaw-callback-history-replace" "zaw-callback-history-append")
    act_descriptions=("execute" "replace edit buffer" "append to edit buffer")
    options="-r"
}

zaw-register-src -n history zaw-src-history


function zaw-callback-history-execute() {
    BUFFER="$1"
    zle accept-line
}

function zaw-callback-history-replace() {
    LBUFFER="$1"
    RBUFFER=""
}

function zaw-callback-history-append() {
    LBUFFER="${BUFFER}$1"
}
