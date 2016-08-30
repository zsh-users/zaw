# zaw source for git files

function zaw-src-git-files-raw() {
    local ret=0
    git rev-parse --git-dir >/dev/null 2>&1
    ret=$?
    if (( ret != 0 )); then
        return ret
    fi

    "$1"
    ret=$?
    if (( ret != 0 )); then
        return ret
    fi

    actions=(zaw-callback-edit-file zaw-src-git-status-add zaw-src-git-status-add-p zaw-src-git-status-reset zaw-src-git-status-checkout zaw-src-git-status-rm zaw-callback-append-to-buffer)
    act_descriptions=("edit file" "add" "add -p" "reset" "checkout" "rm" "append to edit buffer")
    options=(-m -n)
    return 0
}

function zaw-src-git-files-classify-aux() {
    local -a as ms ds os
    : ${(A)as::=${(0)"$(git ls-files $(git rev-parse --show-cdup) -z)"}}
    : ${(A)ms::=${(0)"$(git ls-files $(git rev-parse --show-cdup) -z -m)"}}
    if (( ${#ms} == 0 )) || (( ${#ms} == 1 )) &&  [[ -z "$ms" ]]; then
        candidates=($as)
        return 0
    fi

    if is-at-least 5.0.0 || [[ -n "${ZSH_PATCHLEVEL-}" ]] && \
       is-at-least 1.5637 "$ZSH_PATCHLEVEL"; then
        os=(${as:|ms})
    else
        os=(${as:#(${(~j.|.)ms})}) # TODO: too slower for large work tree
    fi
    candidates=($ms $os)

    : ${(A)ds::=${ms/%/                   MODIFIED}}
    ds+=($os)
    cand_descriptions=($ds)
    return 0
}

function zaw-src-git-files-legacy-aux() {
    : ${(A)candidates::=${(0)"$(git ls-files $(git rev-parse --show-cdup) -z)"}}
    return 0
}

function zaw-src-git-files-add () {
    BUFFER="git add $1"
    zle accept-line
}

{
    function zaw-src-git-files-register-src() {
        eval "function $2 () { zaw-src-git-files-raw "$3" }"
        zaw-register-src -n "$1" "$2"
    }
    zaw-src-git-files-register-src git-files zaw-src-git-files zaw-src-git-files-classify-aux
    zaw-src-git-files-register-src git-files-legacy zaw-src-git-files-legacy{,-aux}
} always {
    unfunction zaw-src-git-files-register-src
}
