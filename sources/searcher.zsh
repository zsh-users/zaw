# zaw source for ack/ag searcher

if (( $+commands[ag] )); then
    ZAW_SEARCHER_CMD="ag"
elif (( $+commands[ack-grep] )); then
    ZAW_SEARCHER_CMD="ack-grep"
elif (( $+commands[ack] )); then
    ZAW_SEARCHER_CMD="ack"
else
    # ack/ag are not found, and disable this source
    return
fi

function zaw-src-searcher() {
    local buf
    read-from-minibuffer "${ZAW_SEARCHER_CMD} "
    buf=$($ZAW_SEARCHER_CMD ${(Q@)${(z)REPLY}})
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

zaw-register-src -n "ack/ag searcher" zaw-src-searcher
