#
# zaw-src-cdr
#
# zaw source for recent directories
#

(( $+functions[cdr] )) || return

function zaw-src-cdr () {
    setopt local_options extended_glob
    : ${(A)candidates::=${${(f)"$(cdr -l)"}##<-> ##}}
    actions=(zaw-src-cdr-cd zaw-src-cdr-insert zaw-src-cdr-prune)
    act_descriptions=("cd" "insert" "prune")
    options=("-m" "-s" "${BUFFER##cd(r|) }")
}

function zaw-src-cdr-cd () {
    BUFFER="cd $1"
    zle accept-line
}

function zaw-src-cdr-insert () {
    [[ -z "$LBUFFER" ]] || LBUFFER+=" "
    [[ "$LBUFFER[-1]" == " " ]] || LBUFFER+=" "
    LBUFFER+="${(j. .)@}"
}

function zaw-src-cdr-prune () {
    local -aU reply
    autoload -Uz chpwd_recent_filehandler
    chpwd_recent_filehandler
    : ${(A)reply::=${reply:#(${(~j.|.)${~@}})}}
    chpwd_recent_filehandler $reply
}

zaw-register-src -n cdr zaw-src-cdr
