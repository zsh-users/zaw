function zaw-src-fasd () {
    candidates=($(fasd -alR))
    actions=(zaw-callback-append-to-buffer)
    act_descriptions=("append to edit buffer")
    options+=(-n -m)
}


function zaw-src-fasd-files () {
    candidates=($(fasd -flR))
    actions=(zaw-callback-append-to-buffer)
    act_descriptions=("append to edit buffer")
    options+=(-n -m)
}


function zaw-src-fasd-directories () {
    candidates=($(fasd -dlR))
    actions=(zaw-callback-append-to-buffer)
    act_descriptions=("append to edit buffer")
    options+=(-n -m)
}


zaw-register-src -n fasd zaw-src-fasd
zaw-register-src -n fasd-directories zaw-src-fasd-directories
zaw-register-src -n fasd-files zaw-src-fasd-files
