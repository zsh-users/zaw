function zaw-src-aliases() {
    candidates=($(alias | cut -d '=' -f 1))
    actions=(zaw-callback-execute zaw-callback-append-to-buffer zaw-callback-replace-buffer view-alias-pager)
    act_descriptions=("execute" "append to buffer" "replace buffer" "view alias")
}

view-alias-pager() {
    alias $1 | ${PAGER:-less}
}

zaw-register-src -n aliases zaw-src-aliases
