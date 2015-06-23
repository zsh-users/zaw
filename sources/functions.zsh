function zaw-src-functions() {
    candidates=($(print -l ${(ok)functions}))
    actions=(zaw-callback-execute zaw-callback-append-to-buffer zaw-callback-replace-buffer functions) 
    act_descriptions=("call function" "append to buffer" "replace buffer" "view source")
}

zaw-register-src -n functions zaw-src-functions
