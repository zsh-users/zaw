zmodload zsh/parameter

function zaw-src-history() {
    if zstyle -t ':filter-select' hist-find-no-dups ; then
        candidates=(${(@vu)history})
        options=("-m" "-s" "${BUFFER}")
    else
        cands_assoc=("${(@kv)history}")
        # have filter-select reverse the order (back to latest command first).
        # somehow, `cands_assoc` gets reversed while `candidates` doesn't. 
        options=("-r" "-m" "-s" "${BUFFER}")
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
