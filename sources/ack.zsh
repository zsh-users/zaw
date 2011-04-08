#
# zaw-src-ack
#
# search using ack and open file
#

zmodload zsh/parameter

if ! (( $+commands[ack] )); then
    # ack not found
    return
fi

autoload -U read-from-minibuffer

function zaw-src-ack() {
    local ack_args REPLY f line ret
    local -a ack_history
    ack_history=( "${(@)${(f)"$(fc -l -n -m "ack --group *" 0 -1)"}#ack --group }" )

    function() {
        local HISTNO
        integer histno=1
        # temporary switch to new empty history
        fc -p -a
        # and add only ack's args to the history
        for ack_args in "${(@)ack_history}"; do
            print -s -r -- "${ack_args}"
            (( histno++ ))
        done
        HISTNO="${histno}"
        read-from-minibuffer "ack --group "
        ret=$?
    }

    if [[ "${ret}" == 0 ]]; then
        ack --group "${(Q@)${(z)REPLY}}" | \
            while read f; do
                while read line; do
                    if [[ -z "${line}" ]]; then
                        break
                    fi
                    candidates+="${f}"
                    cand_descriptions+="${f}:${line}"
                done
            done

        print -s -r -- "ack --group ${REPLY}"

        actions=("zaw-callback-edit-file" "zaw-callback-append-to-buffer")
        act_descriptions=("edit file" "append to edit buffer")
        options=("-m")
    else
        return 1
    fi
}

zaw-register-src -n ack zaw-src-ack
