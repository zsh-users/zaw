function zaw-src-fasd () {
    candidates=($(fasd -al))
    actions=(zaw-callback-append-to-buffer)
    act_descriptions=("append to edit buffer")
    options+=(-n -m)
}


function zaw-src-fasd-files () {
    candidates=($(fasd -fl))
    actions=(zaw-callback-append-to-buffer)
    act_descriptions=("append to edit buffer")
    options+=(-n -m)
}


function zaw-src-fasd-directories () {
    candidates=($(fasd -dl))
    actions=(zaw-callback-append-to-buffer)
    act_descriptions=("append to edit buffer")
    options+=(-n -m)
}


zaw-register-src -n fasd zaw-src-fasd
zaw-register-src -n fasd-directories zaw-src-fasd-directories
zaw-register-src -n fasd-files zaw-src-fasd-files
