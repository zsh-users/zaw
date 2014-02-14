function zaw-src-fasd () {
    candidates=($(fasd -al))
    actions=(zaw-callback-append-to-buffer)
    act_descriptions=("append to edit buffer")
    options+=(-n -m)
}


function zaw-src-fasd-f () {
    candidates=($(fasd -fl))
    actions=(zaw-callback-append-to-buffer)
    act_descriptions=("append to edit buffer")
    options+=(-n -m)
}


function zaw-src-fasd-d () {
    candidates=($(fasd -dl))
    actions=(zaw-callback-append-to-buffer)
    act_descriptions=("append to edit buffer")
    options+=(-n -m)
}


zaw-register-src -n fasd-a zaw-src-fasd-a
zaw-register-src -n fasd-d zaw-src-fasd-d
zaw-register-src -n fasd-f zaw-src-fasd-f
