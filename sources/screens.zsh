#
# zaw-src-screens
#
# select screen session and attache it
#

function zaw-src-screens() {
    local session state

    screen -ls | awk '/^There (is a|are) screens? on:/,/^[0-9]+ Sockets? in/ {if (!/^There (is a|are) screens? on:/&&!/^[0-9]+ Sockets? in/)print}' | \
        while read session state; do
            candidates+=("${session}")
            cand_descriptions+=("${(r:30:::::)session} ${state}")
        done
        actions=('zaw-callback-screens-attach')
        act_descriptions=('attach session')
}

zaw-register-src -n screens zaw-src-screens

function zaw-callback-screens-attach() {
    BUFFER="screen -rx ${(q)1}"
    zle accept-line
}
