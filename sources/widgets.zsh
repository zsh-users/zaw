function zaw-src-widgets() {
    candidates=($(zle -l | cut -d ' ' -f 1))
    actions=(zle-call)
    act_descriptions=("call function with zle")
}

zle-call(){
    zle $1
}

zaw-register-src -n widgets zaw-src-widgets
