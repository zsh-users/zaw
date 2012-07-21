# zaw source for git files

function zaw-src-git-files() {
    local modifies unsorted_candidates
    integer i j k cand_l modi_l
    git rev-parse --git-dir >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        : ${(A)unsorted_candidates::=${(f)"$(git ls-files $(git rev-parse --show-cdup))"}}
        : ${(A)modifies::=${(f)"$(git ls-files $(git rev-parse --show-cdup) --modified)"}}
        cand_l=${#unsorted_candidates}
        modi_l=${#modifies}
        if [[ "$modifies[$modi_l]" != "" ]]; then
            for i in {1..$modi_l}; do
                candidates[$i]="${modifies[$i]}"
                cand_descriptions[$i]="${modifies[$i]}              MODIFIED"
            done
            k=`expr "$modi_l" + 1`
        else
            k=1
        fi
    # This dual loop may be somewhat heavy.
        for i in {1..$cand_l}; do
            for j in {1..$modi_l}; do
                if [[ "${modifies[$j]}" == "${unsorted_candidates[$i]}" ]]; then
                    break
                fi
                if [[ "$j" == "$modi_l" ]]; then
                    candidates[$k]="${unsorted_candidates[$i]}"
                    cand_descriptions[$k]="${unsorted_candidates[$i]}"
                    k=`expr "$k" + 1`
                fi
            done
        done
    fi


    actions=("zaw-callback-edit-file" "zaw-src-git-files-add" "zaw-callback-append-to-buffer")
    act_descriptions=("edit file" "add" "append to edit buffer")
    options=(-m -n)
}

function zaw-src-git-files-add () {
    BUFFER="git add $1"
    zle accept-line
}

zaw-register-src -n git-files zaw-src-git-files
