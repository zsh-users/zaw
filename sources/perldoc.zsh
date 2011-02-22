function zaw-src-perldoc() {
    local code_wanted
    local -a words

    # XXX: override _wanted to capture module list _perl_modules generates
    code_wanted="${functions[_wanted]}"
    function _wanted() {
        candidates=("${(P@)${@[7]}}")
    }

    # required by _perl_modules
    words=(perldoc)

    _perl_modules

    # restore original function
    eval "function _wanted() { $code_wanted }"

    actions=("zaw-callback-perldoc-view" "zaw-callback-perldoc-vim")
    act_descriptions=("view perldoc" "open with vim")
}

zaw-register-src -n perldoc zaw-src-perldoc

function zaw-callback-perldoc-view() {
    local orig_buffer="${BUFFER}"
    BUFFER=" perldoc '$1'"
    zle accept-line
}

function zaw-callback-perldoc-vim() {
    local orig_buffer="${BUFFER}"
    BUFFER=" vim -R $(perldoc -lm "$1")"
    zle accept-line
}
