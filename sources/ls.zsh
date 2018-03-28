#
# zaw-src-ls
#
# list files in current directory, most recent on top
#
# bindkey '^Xl' zaw-ls
#


function zaw-src-ls() {
	# avoid any alias present by calling full path
	savealias=`alias ls`
	[[ "$savealias" = "" ]] || unalias ls

	# list ordered by date, newest first
	allfiles="$( ls -lt -F )"

	[[ "$savealias" = "" ]] || {
		# restore ls alias
		eval $savealias
		unset savealias
	}

	: ${(A)candidates::=${(f)allfiles}}
	actions=(zaw-src-ls-copy zaw-src-ls-append zaw-src-ls-prepend)
	act_descriptions=("copy filename to clipboard"
					  "append filename" "prepend filename")
}

function strip-ls-long() {
	awk '	
{ fname=$9;
  for(i=10; i<=NF; ++i) {
    fname = sprintf("%s\\ %s",fname, $i);
  }
  print fname;
}

'
}

function zaw-src-ls-copy() {
	print -- "$1" | strip-ls-long | xclip -in -selection clipboard
	BUFFER="${BUFFER}`print -- $1 | strip-ls-long`"
}

function zaw-src-ls-append() {
	line="$1"

	BUFFER="$BUFFER `print -- $line | strip-ls-long`"
}

function zaw-src-ls-prepend() {
	line="$1"

	BUFFER="`print -- $line | strip-ls-long` $BUFFER"
}


zaw-register-src -n ls zaw-src-ls
