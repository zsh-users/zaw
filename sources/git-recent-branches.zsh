# zaw source for git branches sorted by commit date

function zaw-src-git-recent-branches () {
    git rev-parse --git-dir >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        local branches="$(git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads)"
        : ${(A)candidates::=${${(f)${branches}}#refs/}}
        : ${(A)cand_descriptions::=${${(f)${branches}}#refs/(remotes|heads|tags)/}}
    fi

    actions=( \
        zaw-src-git-branches-checkout \
        zaw-src-git-branches-simple-checkout \
        zaw-callback-append-to-buffer \
        zaw-src-git-branches-merge \
        zaw-src-git-branches-merge-rebase \
        zaw-src-git-branches-merge-no-ff \
        zaw-src-git-branches-diff \
        zaw-src-git-branches-diff-stat \
        zaw-src-git-branches-reset \
        zaw-src-git-branches-rebase \
        zaw-src-git-branches-rebase-interactive \
        zaw-src-git-branches-create \
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
        "diff" \
        "diff stat" \
        "reset" \
        "rebase" \
        "rebase interactive from..." \
        "create new branch from..." \
        "reset hard" \
        "delete" \
        "delete force")
    options=()
}

function zaw-src-git-recent-all-branches () {
    git rev-parse --git-dir >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        local branches="$(git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads refs/remotes)"
        : ${(A)candidates::=${${(f)${branches}}#refs/}}
        : ${(A)cand_descriptions::=${${(f)${branches}}#refs/(remotes|heads|tags)/}}
    fi

    actions=( \
        zaw-src-git-branches-checkout \
        zaw-src-git-branches-simple-checkout \
        zaw-callback-append-to-buffer \
        zaw-src-git-branches-merge \
        zaw-src-git-branches-merge-rebase \
        zaw-src-git-branches-merge-no-ff \
        zaw-src-git-branches-diff \
        zaw-src-git-branches-diff-stat \
        zaw-src-git-branches-reset \
        zaw-src-git-branches-rebase \
        zaw-src-git-branches-rebase-interactive \
        zaw-src-git-branches-create \
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
        "diff" \
        "diff stat" \
        "reset" \
        "rebase" \
        "rebase interactive from..." \
        "create new branch from..." \
        "reset hard" \
        "delete" \
        "delete force")
    options=()
}

function zaw-src-git-recent-branches-checkout () {
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

function zaw-src-git-branches-diff() {
    local b_name=${1#(heads|remotes|tags)/}
    BUFFER="git diff $b_name"
    zle accept-line
}

function zaw-src-git-branches-diff-stat() {
  local b_name=${1#(heads|remotes|tags)/}
    BUFFER="git diff --stat $b_name"
    zle accept-line
}

zaw-register-src -n git-recent-branches zaw-src-git-recent-branches
zaw-register-src -n git-recent-all-branches zaw-src-git-recent-all-branches
