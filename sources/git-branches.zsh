# zaw source for git branch

function zaw-src-git-branches() {
    git rev-parse --git-dir >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        local branches_list="$(git show-ref | awk ' $2 != "refs/stash" { print $2 }' )"
        : ${(A)candidates::=${${(f)${branches_list}}#refs/}}
        : ${(A)cand_descriptions::=${${(f)${branches_list}}#refs/(remotes|heads|tags)/}}
    fi
    actions=( \
        zaw-src-git-branches-checkout \
        zaw-src-git-branches-simple-checkout \
        zaw-callback-append-to-buffer \
        zaw-src-git-branches-merge \
        zaw-src-git-branches-merge-rebase \
        zaw-src-git-branches-merge-no-ff \
        zaw-src-git-branches-merge-to \
        zaw-src-git-branches-reset \
        zaw-src-git-branches-rebase \
        zaw-src-git-branches-rebase-interactive \
        zaw-src-git-branches-create \
        zaw-src-git-branches-diff \
        zaw-src-git-branches-diff-stat \
        zaw-src-git-branches-reset-hard \
        zaw-src-git-branches-delete \
        zaw-src-git-branches-delete-force)
    act_descriptions=(
        "check out locally" \
        "check out" \
        "append to edit buffer" \
        "merge" \
        "merge rebase" \
        "merge no ff" \
        "merge to" \
        "reset" \
        "rebase" \
        "rebase interactive from..." \
        "create new branch from..." \
        "diff" \
        "diff statistics" \
        "reset hard" \
        "delete" \
        "delete force")
    options=()
}

function zaw-src-git-branches-checkout () {
    local b_type=${1%%/*}
    local b_name=${1#(heads|remotes|tags)/}
    case "$b_type" in
        "heads"|"tags")
            BUFFER="git checkout $b_name"
            zle accept-line
            ;;
        "remotes")
            BUFFER="git checkout -t $b_name"
            zle accept-line
            ;;
    esac
}

function zaw-src-git-branches-simple-checkout () {
    local b_name=${1#(heads|remotes|tags)/}
    BUFFER="git checkout $b_name"
    zle accept-line
}

function zaw-src-git-branches-create () {
    local b_name=${1#(heads|remotes|tags)/}
    LBUFFER="git checkout -b "
    RBUFFER=" $b_name"
}

function zaw-src-git-branches-merge () {
    local b_type=${1%%/*}
    local b_name=${1#(heads|remotes|tags)/}
    BUFFER="git merge $b_name"
    zle accept-line
}

function zaw-src-git-branches-merge-rebase () {
    local b_type=${1%%/*}
    local b_name=${1#(heads|remotes|tags)/}
    BUFFER="git merge --rebase $b_name"
    zle accept-line
}

function zaw-src-git-branches-merge-no-ff () {
    local b_type=${1%%/*}
    local b_name=${1#(heads|remotes|tags)/}
    BUFFER="git merge --no-ff $b_name"
    zle accept-line
}

function zaw-src-git-branches-merge-to () {
    local b_type=${1%%/*}
    local b_name=${1#(heads|remotes|tags)/}
    local b_now=${$(git symbolic-ref HEAD)#refs/heads/}
    if [[ "$b_type" == "heads" ]]; then
        BUFFER="git checkout $b_name && git merge --no-ff $b_now"
        zle accept-line
    fi
}

function zaw-src-git-branches-reset () {
    local b_type=${1%%/*}
    local b_name=${1#(heads|remotes|tags)/}
    BUFFER="git reset $b_name"
    zle accept-line
}

function zaw-src-git-branches-diff() {
    local b_name=${1#(heads|remotes|tags)/}
    BUFFER="git diff $b_name"
    zle accept-line
}

function zaw-src-git-branches-diff-stat() {
  local b_name=${1#(heads|remotes|tags)/}
    BUFFER="git diff --stat $b_name"
}

function zaw-src-git-branches-reset-hard () {
    local b_type=${1%%/*}
    local b_name=${1#(heads|remotes|tags)/}
    BUFFER="git reset --hard $b_name"
    zle accept-line
}

function zaw-src-git-branches-rebase () {
    local b_type=${1%%/*}
    local b_name=${1#(heads|remotes|tags)/}
    BUFFER="git rebase $b_name"
    zle accept-line
}

function zaw-src-git-branches-rebase-interactive () {
    local b_type=${1%%/*}
    local b_name=${1#(heads|remotes|tags)/}
    BUFFER="git rebase -i $b_name"
    zle accept-line
}

function zaw-src-git-branches-delete () {
    local b_type=${1%%/*}
    local b_name=${1#(heads|remotes|tags)/}
    if [[ "$b_type" == "heads" ]] ; then
        BUFFER="git branch -d $b_name"
        zle accept-line
    elif [[ "$b_type" == "remotes" ]] ; then
        local b_loc=${b_name%%/*}
        local b_base=${b_name#$b_loc/}
        BUFFER="git push $b_loc :$b_base"
        zle accept-line
    fi
}

function zaw-src-git-branches-delete-force () {
    local b_type=${1%%/*}
    local b_name=${1#(heads|remotes|tags)/}
    if [[ "$b_type" == "heads" ]] ; then
        BUFFER="git branch -D $b_name"
        zle accept-line
    elif [[ "$b_type" == "remotes" ]] ; then
        local b_loc=${b_name%%/*}
        local b_base=${b_name#$b_loc/}
        BUFFER="git push $b_loc :$b_base"
        zle accept-line
    fi
}

zaw-register-src -n git-branches zaw-src-git-branches
