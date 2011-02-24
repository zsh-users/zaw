function zaw-src-git-files() {
    git rev-parse --git-dir >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        candidates=("${(ps:\0:)$(git ls-files -z)[1,-2]}")
    fi
    actions=("zaw-callback-edit-file" "zaw-callback-append-to-buffer")
    act_descriptions=("edit file" "append to edit buffer")
    options=("-m")
}

zaw-register-src -n git-files zaw-src-git-files
