
function zaw-src-git-log() {
    git rev-parse --git-dir >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        local desc="$(git log --all --graph --decorate --oneline --no-color)"
        
        : ${(A)cand_descriptions::=${(f)desc}}
        : ${(A)candidates::=${(f)desc}}
    fi
    actions=(zaw-src-git-log-insert \
             zaw-src-git-log-reset \
             zaw-src-git-log-reset-hard \
             zaw-src-git-log-cherry-pick \
             zaw-src-git-log-create-branch \
             zaw-src-git-log-revert)
    act_descriptions=("insert" \
                      "reset" \
                      "reset --hard" \
                      "cherry-pick" \
                      "create new branch from this hash value" \
                      "revert")
    options=()
}

function _zaw-src-git-log-strip(){
    echo $1 | sed -e 's/^[*|/\\ ]* \([a-f0-9]*\) .*/\1/'
}

function zaw-src-git-log-insert(){
    local hash_val=$(_zaw-src-git-log-strip $1)
    zaw-callback-append-to-buffer $hash_val
}

function zaw-src-git-log-reset(){
    local hash_val=$(_zaw-src-git-log-strip $1)
    BUFFER="git reset $hash_val"
    zle accept-line
}

function zaw-src-git-log-reset-hard(){
    local hash_val=$(_zaw-src-git-log-strip $1)
    BUFFER="git reset --hard $hash_val"
    zle accept-line
}

function zaw-src-git-log-cherry-pick(){
    local hash_val=$(_zaw-src-git-log-strip $1)
    BUFFER="git cherry-pick $hash_val"
    zle accept-line
}

function zaw-src-git-log-create-branch(){
    local hash_val=$(_zaw-src-git-log-strip $1)
    LBUFFER="git checkout -b "
    RBUFFER=" $hash_val"
}

function zaw-src-git-log-revert(){
    local hash_val=$(_zaw-src-git-log-strip $1)
    BUFFER="git revert $hash_val"
    zle accept-line
}

zaw-register-src -n git-log zaw-src-git-log
