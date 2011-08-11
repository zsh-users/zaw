#!/bin/zsh
#
# zaw-launcher.zsh
#
# launcher script to start zaw as command

# source zaw.zsh
local this_file="$0"
local cur_dir="${this_file:A:h}"
source "${cur_dir}/zaw.zsh"


# parse arguments
do_eval=0

while getopts 'eh' opt; do
    case "${opt}" in
        e)
            do_eval=1
            ;;

        h)
            print \
"Usage: $0 [options] [source name]

Options:
  -h     show this help
  -e     eval result string
"
            exit
            ;;
    esac
done

if (( OPTIND > 1 )); then
    shift $(( OPTIND - 1 ))
fi

zaw_args=()
if [[ $# > 0 && "${zaw_sources[$1]}" != "" ]]; then
    zaw_args+="${zaw_sources[$1]}"
fi


# use zle-line-init to start zaw right after vared
function zle-line-init() {
    zle zaw "${(@)zaw_args}"

    # return from vared
    zle accept-line
}
zle -N zle-line-init

vared -c cmd

if (( do_eval )); then
    eval "${cmd}"
else
    print "${cmd}"
fi
