#
# zaw-src-aliases
#
# select an alias and expand it
#

zmodload zsh/parameter

autoload -U read-from-minibuffer

function zaw-src-aliases() {
    local REPLY f line ret
    if [[ "$LBUFFER" =~ "\w" ]]; then
        candidates=("${(v@)galiases}")
        cand_descriptions=("${(k@)galiases}")
    else
        candidates=("${(v@)aliases}")
        cand_descriptions=("${(k@)aliases}")
    fi
    actions=("zaw-callback-append-to-buffer" "zaw-callback-execute")
    act_descriptions=("append to edit buffer" "execute")
}

zaw-register-src -n aliases zaw-src-aliases
