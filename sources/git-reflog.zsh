function zaw-src-git-reflog () {
    git rev-parse --git-dir >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        git reflog | \
            while read id desc; do
                candidates+=("${id}")
                cand_descriptions+=("${id} ${desc}")
            done
    fi
    actions=(zaw-callback-append-to-buffer zaw-src-git-commit-checkout zaw-src-git-commit-reset zaw-src-git-commit-rebase zaw-src-git-commit-rebase-interactive zaw-src-git-commit-reset-hard)
    act_descriptions=("append to edit buffer" "checkout" "reset" "rebase" "rebase interactive from..." "reset hard")
    options=()
}

function zaw-src-git-commit-checkout () {
    BUFFER="git checkout $1"
    zle accept-line
}

function zaw-src-git-commit-reset () {
    BUFFER="git reset $1"
    zle accept-line
}

function zaw-src-git-commit-reset-hard () {
    BUFFER="git reset --hard $1"
    zle accept-line
}

function zaw-src-git-commit-rebase () {
    BUFFER="git rebase $1"
    zle accept-line
}

function zaw-src-git-commit-rebase-interactive () {
    BUFFER="git rebase -i $1"
    zle accept-line
}

zaw-register-src -n git-reflog zaw-src-git-reflog
