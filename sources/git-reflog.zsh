function zaw-src-git-reflog () {
    git rev-parse --git-dir >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        git reflog | \
            while read id desc; do
                candidates+=("${id}")
                cand_descriptions+=("${id} ${desc}")
            done
    fi
    actions=(zaw-callback-append-to-buffer)
    act_descriptions=("append to edit buffer")
    options=()
}

zaw-register-src -n git-reflog zaw-src-git-reflog
