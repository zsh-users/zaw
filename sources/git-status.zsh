function zaw-src-git-status() {
  git rev-parse --git-dir >/dev/null 2>&1
    if [[ $? == 0 ]]; then
      local file_list="$(git status --porcelain)"
      : ${(A)candidates::=${(f)${file_list}}}

      : ${(A)cand_descriptions::=${${(f)${file_list}}/ M /[modified]    }}
      : ${(A)cand_descriptions::=${${(M)cand_descriptions}/M  /[staged]      }}
      : ${(A)cand_descriptions::=${${(M)cand_descriptions}/A  /[staged(add)] }}
      : ${(A)cand_descriptions::=${${(M)cand_descriptions}/\?\? /[untracked]   }}

    fi

    actions=(zaw-src-git-status-add zaw-src-git-status-add-p zaw-src-git-status-reset zaw-src-git-status-checkout)
    act_descriptions=("add" "add -p" "reset" "checkout")
    options=()
}

function zaw-src-git-status-add() {
  local f_path=${1#(\?\? | M |M  |A  )}
  local git_base="$(git rev-parse --show-cdup)"
  BUFFER="git add $git_base$f_path"
  zle accept-line
}

function zaw-src-git-status-add-p() {
  local f_path=${1#(\?\? | M |M  |A  )}
  local git_base="$(git rev-parse --show-cdup)"
  BUFFER="git add -p $git_base$f_path"
  zle accept-line
}

function zaw-src-git-status-reset() {
  local f_path=${1#(\?\? | M |M  |A  )}
  local git_base="$(git rev-parse --show-cdup)"
  BUFFER="git reset $git_base$f_path"
  zle accept-line
}

function zaw-src-git-status-checkout() {
  local f_path=${1#(\?\? | M |M  |A  )}
  local git_base="$(git rev-parse --show-cdup)"
  BUFFER="git checkout $git_base$f_path"
  zle accept-line
}

zaw-register-src -n git-status zaw-src-git-status
