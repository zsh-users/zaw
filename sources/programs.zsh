function zaw-src-programs() {
    # fill the command hash
    hash -r
    hash -f
    candidates=($(hash | cut -d '=' -f 1))
    actions=(zaw-callback-execute zaw-callback-append-to-buffer zaw-callback-replace-buffer)
    act_descriptions=("execute" "append to buffer" "replace buffer")
}

zaw-register-src -n programs zaw-src-programs
