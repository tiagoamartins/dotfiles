# ~/.bashrc

[ ! -r "$HOME/.shrc" ] || . "$HOME/.shrc"

# Make directory variables able to change directory
shopt -s extglob cdable_vars 2>/dev/null

# Don't save history upon exiting
export HISTCONTROL=ignoredups
unset HISTFILE

# Get user ID
[ "$UID" ] || UID=`id -u`

# Set prompt colors
usercolor='01;34'
atcolor='01;37'
hostcolor='01;33'
dircolor='01;36'
case "$TERM" in
	*-256color)
		usercolor='1;38;5;33'  # Blue
		atcolor='1;38;5;136'   # Yellow
		hostcolor='1;38;5;166' # Orange
		dircolor='1;38;5;37';; # Cyan
	*-88color|rxvt-unicode)
		usercolor='1;38;5;23'
		atcolor='1;38;5;72'
		hostcolor='1;38;5;68'
		dircolor='1;38;5;26';;
esac

# If root change color to RED
[ $UID = '0' ] && usercolor="01;31"

# Get TTY number
if [ -x /usr/bin/tty -o -x /usr/local/bin/tty ]
then
	ttybracket=" [`tty|sed -e s,^/dev/,,`]"
	ttyat="`tty|sed -e s,^/dev/,,`@"
fi

# Set prompt as 'user@host:directory $ '
PS1='\[\e['$usercolor'm\]\u\[\e['$atcolor'm\]@\[\e['$hostcolor'm\]\h\[\e[0;1m\]:\[\e['$dircolor'm\]\w\[\e[0;1m\] \$ \[\e[00m\]'

# Set icon name and window title
case "$TERM" in
	screen*|xterm*|rxvt*|Eterm*|kterm*|dtterm*|ansi*|cygwin*|tmux*)
		PS1='\[\e]1;'$ttyat'\h\007\e]2;\u@\h:\w'$ttybracket'\007\]'"${PS1//01;3/00;9}";;
	linux*|vt220*) ;;
	*)
		PS1='\u@\h:\w \$ ';;
esac

# Set screen/tmux window title
case $TERM in
	screen*|tmux*)
		PS1="$PS1"'\[\ek'"$ttyat`[ "$STY" -o "$TMUX" ] || echo '\h'`"'\e\\\]';;
esac

# Load completion
[ ! -f /etc/bash_completion ] || . /etc/bash_completion

# Generate completion
_tiago() {
	while [ -x "$HOME/.local/bin/${COMP_WORDS[0]}-${COMP_WORDS[1]}" ]
	do
		COMP_WORDS=("${COMP_WORDS[0]}-${COMP_WORDS[1]}" "${COMP_WORDS[@]:2}")
		COMP_CWORD=$((COMP_CWORD-1))
	done
	local cmd=${COMP_WORDS[0]} sub=${COMP_WORDS[1]} cur=${COMP_WORDS[COMP_CWORD]}
	if [[ $COMP_CWORD == 1 ]]
	then
		COMPREPLY=($(compgen -W "$(grep '^	[a-z-]*[|)]' "$HOME/.local/bin/$cmd" | sed -e 's/).*//' | tr '|' ' ')" "$cur"))
	else
		local selector=$(egrep "^	([a-z-]*[|])*$sub([|][a-z-]*)*[)] *# *[_a-z-]*$" "$HOME/.local/bin/$cmd" | sed -e 's/.*# *//')
		case "$selector" in
			hosts|ssh)
				COMPREPLY=($(compgen -W "localhost $(tiago host list)" "$cur"));;
			directories)
				COMPREPLY=($(compgen -d "$cur"));;
			precommand)
				COMPREPLY=($(compgen -c "$cur"));;
			nothing)
				COMPREPLY=();;
			*)
				COMPREPLY=($(compgen -f "$cur"));;
		esac
	fi
}

complete -F _tiago tiago

# Cleanup
unset hostcolor usercolor dircolor ttybracket ttyat
