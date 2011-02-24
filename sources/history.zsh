zmodload zsh/parameter

function zaw-src-history() {
    cands_assoc=("${(@kv)history}")
    actions=("zaw-callback-execute" "zaw-callback-replace-buffer" "zaw-callback-append-to-buffer")
    act_descriptions=("execute" "replace edit buffer" "append to edit buffer")
    options=("-r")
}

zaw-register-src -n history zaw-src-history
