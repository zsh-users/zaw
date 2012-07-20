# zaw source for git files 

function zaw-src-git-files() {
    local modifies
    integer i j cand_l modi_l
    git rev-parse --git-dir >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        : ${(A)candidates::=${(f)"$(git ls-files $(git rev-parse --show-cdup))"}}
        : ${(A)modifies::=${(f)"$(git ls-files $(git rev-parse --show-cdup) --modified)"}}
        : ${(A)cand_descriptions::=${(f)"$(git ls-files $(git rev-parse --show-cdup))"}}
        cand_l=${#candidates}
        modi_l=${#modifies}
    fi
    # This dual loop may be somewhat heavy.
    for i in {1..$modi_l}; do
        for j in {1..$cand_l}; do
            if [[ "${modifies[$i]}" == "${candidates[$j]}" ]]; then
                cand_descriptions[$j]="${cand_descriptions[$j]}     MODIFIED"
            fi
        done
    done
    actions=("zaw-callback-edit-file" "zaw-src-git-files-add" "zaw-callback-append-to-buffer")
    act_descriptions=("edit file" "add" "append to edit buffer")
    options=(-m -n)
}

function zaw-src-git-files-add () {
    BUFFER="git add $1"
    zle accept-line
}

zaw-register-src -n git-files zaw-src-git-files
