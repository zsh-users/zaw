# zaw source for git files

function zaw-src-git-files() {
    local all_files modified raw_candidates raw_cand_descriptions
    local all_without_modified mod_description
    git rev-parse --git-dir >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        all_files=$(git ls-files $(git rev-parse --show-cdup))
        modified=$(git ls-files $(git rev-parse --show-cdup) --modified)
        if [[ $modified == "" ]]; then
            raw_candidates=$all_files
            raw_cand_descriptions=$all_files
        else
            mod_description=$(echo $modified | awk '{print $0 "                   MODIFIED"}')
            all_without_modified=$(echo "${modified}\\n${all_files}" |sort |uniq -u )
            raw_candidates=$(echo "${modified}\\n${all_without_modified}")
            raw_cand_descriptions=$(echo "${mod_description}\\n${all_without_modified}")
        fi
        : ${(A)candidates::=${(f)"$(echo $raw_candidates)"}}
        : ${(A)cand_descriptions::=${(f)"$(echo $raw_cand_descriptions)"}}

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
