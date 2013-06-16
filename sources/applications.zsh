#
# zaw-src-applications
#
# zaw source for desktop applications
#

function zaw-src-applications() {
    emulate -L zsh
    setopt local_options extended_glob null_glob

    case "$OSTYPE" in
        [Dd]arwin*)
            candidates=({,~}/Applications{,/Utilities}/*.app(N) /System/Library/CoreServices/*.app(N))
            actions=("zaw-callback-launch-macapp" "zaw-callback-append-to-buffer")
            act_descriptions=("execute application" "append to edit buffer")
            ;;
        [Ll]inux*|*[Bb][Ss][Dd]*|[Ss]olaris*|[Ss]un[Oo][Ss]*)
            local d
            local -a match mbegin mend
            for d in /usr/share/applications/*.desktop; do
                local name="" comment="" exec_="" terminal=0 no_display=0
                while read line; do
                    case "${line}" in
                        Name=(#b)(*))
                            name="${match[1]}"
                            ;;
                        Comment=(#b)(*))
                            comment="${match[1]}"
                            ;;
                        Exec=(#b)(*))
                            exec_="${match[1]}"
                            ;;
                        Terminal=true)
                            terminal=1
                            ;;

                        NoDisplay=true)
                            no_display=1
                            ;;
                    esac
                done < "${d}"

                if (( no_display )); then
                    continue
                fi

                # TODO: % expansion in $exec_
                # remove args that match %* from $exec_
                exec_="${(@m)${(z)exec_}:#%*}"

                if ! (( terminal )); then
                    # disown
                    exec_="${exec_} &!"
                fi

                candidates+=( "${exec_}" )
                cand_descriptions+=( "${name} - ${comment}" )
            done
            actions=("zaw-callback-execute" "zaw-callback-append-to-buffer")
            act_descriptions=("execute application" "append to edit buffer")
            ;;
        *)
            # Unsupported OS
            candidates=( )
            actions=("zaw-callback-execute" "zaw-callback-append-to-buffer")
            act_descriptions=("execute application" "append to edit buffer")
            ;;
    esac

}

function zaw-callback-launch-macapp() {
    BUFFER="open -a \"${(j:; :)@}\""
    zle accept-line
}

zaw-register-src -n applications zaw-src-applications
