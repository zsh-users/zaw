
function zaw-src-git-log() {
    git rev-parse --git-dir >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        local desc="$(git log --all --graph --decorate --oneline)"
        : ${(A)cand_descriptions::=${(f)desc}}
        : ${(A)candidates::=${(f)desc}}
    fi
    actions=(zaw-src-git-log-insert)
    act_descriptions=("insert")
    options=()
}

function _zaw-src-git-log-strip(){
    echo $1 | sed -e 's/^[*|/\\ ]* \([a-f0-9]*\) .*/\1/'
}

function zaw-src-git-log-insert(){
    local hash_val=$(_zaw-src-git-log-strip $1)
    zaw-callback-append-to-buffer $hash_val
}

zaw-register-src -n git-log zaw-src-git-log
