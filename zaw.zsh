#
# zaw - zsh anything like widget
#
# usage:
#
#   add following line to your .zshrc::
#
#     source /path/to/zaw.zsh
#
#   and type "^X^Z"

local cur_dir="${${(%):-%N}:a:h}"
fpath+=("${cur_dir}")

autoload -U filter-select

zaw_sources=()

function zaw-register-src() {
    # register zaw source
    #
    # zaw-register-src [-n NAME] SOURCE
    #
    # SOURCE is function name that define (overrite) these variables
    #
    # $candidates       -> array of candidates
    # $cands_assoc      -> assoc array of candidates
    # $descriptions     -> (optional) array or assoc array of candidates descriptions
    # $actions          -> list of callback function names that receive selected item
    # $act_descriptions -> (optional) list of callback function descriptions
    # $options          -> (optional) options passed to filter-select
    #
    # whether one of candidates or cands-assoc is required
    local name func widget_name

    while getopts 'n:' opts; do
        name="${OPTARG}"
    done
    if (( OPTIND > 1 )); then
        shift $(( OPTIND - 1 ))
    fi

    func="$1"

    if [[ -z "${name}" ]]; then
        name="${func}"
    fi

    # TODO: check name duplication
    zaw_sources+=("${name}" "${func}")

    # define shortcut function
    widget_name="zaw-${(L)name// /-}"
    eval "function ${widget_name} { zle zaw ${func} }"
    eval "zle -N ${widget_name}"
}


function zaw() {
    local options selected action
    local -a reply candidates actions act_descriptions
    local -A cands_assoc

    # save ZLE related variables
    local orig_lbuffer="${LBUFFER}"
    local orig_rbuffer="${RBUFFER}"
    LBUFFER=""
    RBUFFER=""

    if [[ $# == 0 ]]; then
        if zle zaw-select-src; then
            func="${reply[2]}"
            reply=()
        else
            LBUFFER="${orig_lbuffer}"
            RBUFFER="${orig_rbuffer}"
            return 0
        fi
    else
        func="$1"
    fi

    # call source function to generate candidates
    "${func}"

    reply=()

    # call filter-select to allow user select item
    if (( $#cands_assoc )); then
        filter-select -e select-action -A cands_assoc ${options}
    else
        filter-select -e select-action ${options} -- "${(@)candidates}"
    fi

    if [[ $? == 0 ]]; then
        selected="${reply[2]}"

        case "${reply[1]}" in
            accept-line)
                action="${actions[1]}"
                ;;
            accept-search)
                action="${actions[2]}"
                ;;
            select-action)
                reply=()
                filter-select -t "select action for '${selected}'" -d act_descriptions -- "${(@)actions}"
                ret=$?

                if [[ $ret == 0 ]]; then
                    action="${reply[2]}"
                else
                    LBUFFER="${orig_lbuffer}"
                    RBUFFER="${orig_rbuffer}"
                    return 1
                fi
                ;;
        esac

        LBUFFER="${orig_lbuffer}"
        RBUFFER="${orig_rbuffer}"

        "${action}" "${selected}"
    else
        LBUFFER="${orig_lbuffer}"
        RBUFFER="${orig_rbuffer}"
    fi
}

zle -N zaw


function zaw-select-src() {
    local -a cands descs
    cands=()
    descs=()
    for name func in "${(@)zaw_sources}"; do
        cands+="${func}"
        descs+="${name}"
    done

    filter-select -e select-action -d descs -- "${(@)cands}"
}

zle -N zaw-select-src


function zaw-print-src() {
    local name func widget_name
    for name func in "${(@)zaw_sources}"; do
        widget_name="zaw-${(L)name// /-}"
        print "${name}" "${widget_name}"
    done
}


# load zaw sources
local src_dir="${cur_dir}/sources"
if [[ -d "${src_dir}" ]]; then
    for f ("${src_dir}"/*) source "${f}"
fi

# dummy function
function select-action() {}; zle -N select-action
filter-select -i
bindkey -M filterselect '^i' select-action

bindkey '^X^Z' zaw
