#
# zaw-open-file
#
# zaw source for gnome-open to open file
#

function zaw-src-open-file() {
    local root parent d f
    setopt local_options null_glob

    if (( $# == 0 )); then
        root="${PWD}/"
    else
        root="$1"
    fi

    parent="${root:h}"
    if [[ "${parent}" != */ ]]; then
        parent="${parent}/"
    fi
    candidates+=("${parent}")
    cand_descriptions+=("../")

    # TODO: symlink to directory
    for d in "${root%/}"/*(/); do
        candidates+=("${d}/")
        cand_descriptions+=("${d:t}/")
    done

    for f in "${root%/}"/*(^/); do
        candidates+=("${f}")
        cand_descriptions+=("${f:t}")
    done

    actions=( "zaw-callback-open-file" "zaw-callback-append-to-buffer" )
    act_descriptions=( "open file or directory" "append to edit buffer" )
    # TODO: open multiple files
    #options=( "-m" )
    options=( "-t" "${root}" )
}

zaw-register-src -n open-file zaw-src-open-file

function zaw-callback-open-file() {
    # TODO: symlink to directory
    if [[ -d "$1" ]]; then
        zaw zaw-src-open-file "$1"
    else
        BUFFER="gnome-open ${(q)1}"
        accept-line
    fi
}
