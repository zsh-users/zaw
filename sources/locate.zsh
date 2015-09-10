# zaw source for locate

autoload -U read-from-minibuffer

function zaw-src-locate() {
    local buf
    read-from-minibuffer "locate "
    buf=$(locate ${(Q@)${(z)REPLY}})
    if [[ $? != 0 ]]; then
        return 1
    fi
    : ${(A)candidates::=${(f)buf}}
    : ${(A)cand_descriptions::=${(f)buf}}
    actions=( zaw-callback-append-to-buffer )
    act_descriptions=( "append to buffer" )
}

zaw-register-src -n locate zaw-src-locate

