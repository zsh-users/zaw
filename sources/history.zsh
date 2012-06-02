zmodload zsh/parameter

function zaw-src-history() {
    if (( ZAW_HISTORY_LIMIT > 0 )); then
        # use last $ZAW_HISTORY_LIMIT lines
        candidates=("${(@v)history:0:${ZAW_HISTORY_LIMIT}}")
        options=("-m")
    else
        # use all history
        cands_assoc=("${(@kv)history}")
        options=("-m" "-r")
    fi

    actions=("zaw-callback-execute" "zaw-callback-replace-buffer" "zaw-callback-append-to-buffer")
    act_descriptions=("execute" "replace edit buffer" "append to edit buffer")

    if (( $+functions[zaw-bookmark-add] )); then
        # zaw-src-bookmark is available
        actions+="zaw-bookmark-add"
        act_descriptions+="bookmark this command line"
    fi
}

zaw-register-src -n history zaw-src-history
