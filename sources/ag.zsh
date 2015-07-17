#
# zaw-src-ag
#
# search using ag and open file
#

zmodload zsh/parameter

if (( $+commands[ag] )); then
    AG_COMMAND="ag"
else
    # ag not found
    return
fi

autoload -U read-from-minibuffer

function zaw-src-ag() {
    local ag_args REPLY f line ret cand
    local -a ag_history
    ag_history=( "${(@)${(f)"$(fc -l -n -m "$AG_COMMAND *" 0 -1)"}#ag }" )

    function() {
        local HISTNO
        integer histno=1
        # temporary switch to new empty history
        fc -p -a
        # and add only ag's args to the history
        # for ag_args in "${(@)ag_history}"; do
        #     print -s -r -- "${ag_args}"
        #     (( histno++ ))
        # done
        HISTNO="${histno}"
        read-from-minibuffer "${AG_COMMAND} "
        ret=$?
    }

    if [[ "${ret}" == 0 ]]; then
        $AG_COMMAND --group --nocolor "${(Q@)${(z)REPLY}}" | \
            while read f; do
                while read line; do
                    if [[ -z "${line}" ]]; then
                        break
                    fi

                    if [ ! ${ZAW_EDITOR_JUMP_PARAM} ]; then
                        ZAW_EDITOR_JUMP_PARAM="+%LINE% %FILE%"
                    fi

                    cand="${ZAW_EDITOR_JUMP_PARAM/\%LINE\%/${line/:*/}}"
                    cand="${cand/\%FILE\%/${f}}"

                    candidates+="${cand}"
                    cand_short=`echo ${f} | awk -F'/' '{if (NF>3){LASTDIR=NF-1; print $1"/.../"$LASTDIR"/"$NF;} else {print $0}}'`
                    cand_descriptions+="${cand_short}:${line}"
                done
            done

        print -s -r -- "${AG_COMMAND} ${REPLY}"

        actions=("zaw-src-ag-open-file" "zaw-callback-append-to-buffer")
        act_descriptions=("edit file" "append to edit buffer")
        options=("-m")
    else
        return 1
    fi
}

function zaw-src-ag-open-file() {
    if [ ! ${ZAW_EDITOR} ]; then
        ZAW_EDITOR=${EDITOR}
    fi
    BUFFER="${ZAW_EDITOR} $1"
   zle accept-line
}

zaw-register-src -n ag zaw-src-ag
