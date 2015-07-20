# zaw source for ack/ag searcher

function zaw-src-searcher() {
    local buf
    read-from-minibuffer "ag "
    buf=$(ag ${(Q@)${(z)REPLY}})
    : ${(A)candidates::=${(f)buf}}
    : ${(A)cand_descriptions::=${(f)buf}}
    actions=(\
        zaw-src-searcher-edit \
    )
    act_descriptions=(\
        "Edit" \
    )
}

function zaw-src-searcher-edit () {
    local filename=${1%%:*}
    local line=${${1#*:}%%:*}
    BUFFER="${EDITOR} +$line $filename"
    zle accept-line
}

zaw-register-src -n searcher zaw-src-searcher
