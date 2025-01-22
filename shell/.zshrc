# ~/.zshrc

# External {{{1

[ ! -r "$HOME/.shrc" ] || . "$HOME/.shrc"

# }}}1
# Prompt {{{1

autoload -Uz colors && colors

local basecolor="$fg_bold[white]"
local branchcolor="$fg_bold[white]"
local usercolor="$fg_bold[blue]"
local atcolor="$fg_bold[white]"
local hostcolor="$fg_bold[yellow]"
local dircolor="$fg_bold[cyan]"
local hashcolor="$fg_bold[white]"
# Use echotc Co?
case "$TERM" in
	*-256color|*-direct)
		basecolor=$'\e[1;38;5;244m'
		branchcolor=$'\e[1;38;5;136m'
		usercolor=$'\e[1;38;5;33m'
		atcolor=$'\e[1;38;5;136m'
		hostcolor=$'\e[1;38;5;166m'
		dircolor=$'\e[1;38;5;37m'
		hashcolor=$'\e[1;38;5;231m';;
	*-88color|rxvt-unicode)
		basecolor=$'\e[1;38;5;83m'
		branchcolor=$'\e[1;38;5;72m'
		usercolor=$'\e[1;38;5;23m'
		atcolor=$'\e[1;38;5;72m'
		hostcolor=$'\e[1;38;5;68m'
		dircolor=$'\e[1;38;5;26m'
		hashcolor=$'\e[1;38;5;79m';;
	xterm*)
		basecolor=$'\e[01;37m'
		branchcolor=$'\e[01;37m';;
esac
[ $UID = '0' ] && usercolor="$fg_bold[red]"
reset_color=$'\e[00m'

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' formats "%{$basecolor%}[%{$branchcolor%}%20>..>%b%<<%{$basecolor%}]"
zstyle ':vcs_info:*' actionformats "%{$basecolor%}[%{$branchcolor%}%20>..>%b%{$basecolor%}|%F{red}%a%<<%{$basecolor%}]"
zstyle ':vcs_info:hg*:*' get-revision true
zstyle ':vcs_info:hg*:*' get-bookmarks true
zstyle ':vcs_info:hg*:*' get-mq false
zstyle ':vcs_info:hg*:*' branchformat "%b" # only show branch
zstyle ':vcs_info:hg+gen-hg-bookmark-string:*' hooks hgbookmarks

function +vi-hgbookmarks() {
	# The default is to connect all bookmark names by
	# commas. This mixes things up a little.
	# Imagine, there's one type of bookmarks that is
	# special to you. Say, because it's *your* work.
	# Those bookmarks look always like this: "sh/*"
	# (because your initials are sh, for example).
	# This makes the bookmarks string use only those
	# bookmarks. If there's more than one, it
	# concatenates them using commas.
	# The bookmarks returned by `hg' are available in
	# the function's positional parameters.
	local s="${(Mj:,:)@:#*}"
	# Now, the communication with the code that calls
	# the hook functions is done via the hook_com[]
	# hash. The key at which the `gen-hg-bookmark-string'
	# hook looks is `hg-bookmark-string'. So:
	hook_com[hg-bookmark-string]=$s
	# And to signal that we want to use the string we
	# just generated, set the special variable `ret' to
	# something other than the default zero:
	ret=1
	return 0
}

PROMPT="%{$usercolor%}%n%{$atcolor%}@%{${hostcolor}%}%m%{$hashcolor%}:%{$dircolor%}%30<...<%~%<<%{$reset_color%}\${vcs_info_msg_0_} %{$hashcolor%}%# %{$reset_color%}"
RPS1="%(?..(%{"$'\e[01;35m'"%}%?%{$reset_color%}%)%<<)"
setopt promptsubst

_set_title() {
	case "$1" in
		*install*)
			hash -r;;
	esac
	print -Pn '\e]1;%l@%m${1+*}\a'
	print -Pn '\e]2;%n@%m:%~'
	if [ -n "$1" ]
	then
		print -Pnr ' (%24>..>$1%>>)' | tr '\0-\037' '?'
	fi
	print -Pn " [%l]\a"
}

case $TERM in
	screen*|tmux*)
		PROMPT="${PROMPT//01;3/00;9}"
		precmd() {
			_set_title "$@"
			if [ "$STY" -o "$TMUX" ]
			then
				# print -Pn "\e]1;\a\e]1;@%m\a"
				print -Pn '\ek@\e\\'
			else
				print -Pn '\ek@%m\e\\'
			fi
		}
		preexec() {
			_set_title "$@"
			print -n "\ek"
			print -Pnr '%10>..>$1' | tr '\0-\037' '?'
			if [ "$STY" -o "$TMUX" ]
			then
				print -Pn '@\e\\'
			else
				print -Pn '@%m\e\\'
			fi
		};;

	xterm*|rxvt*|Eterm*|kterm*|putty*|dtterm*|ansi*|cygwin*|foot*)
		PROMPT="${PROMPT//01;3/00;9}"
		precmd () {
		    _set_title "$@"
		}
		preexec() {
		    _set_title "$@"
		};;

	linux*|vt220*) ;;

	*)
		PS1="%n@%m:%~%# "
		RPS1="%(?..(%?%)%<<)";;
esac

unset hostcolor dircolor usercolor atcolor hashcolor reset_color

# Options {{{1

setopt autocd
setopt cdable_vars
setopt completeinword
setopt extendedglob
setopt histexpiredupsfirst
setopt histignoredups
setopt histreduceblanks
setopt rmstarsilent
unsetopt nomatch

if [[ $ZSH_VERSION == 3.<->* ]]
then
	which zmodload >& /dev/null && zmodload zsh/compctl
	compctl -c sudo
	compctl -c which
	compctl -g '*(-/)' + -g '.*(-/)' -v cd pushd rmdir
	compctl -k hosts -x 'p[2,-1]' -l '' -- rsh ssh
	return 0
fi

fpath=($fpath ~/.zsh/functions ~/.zsh/functions.zwc)
watch=(notme)
PERIOD=3600
periodic() { rehash }

# }}}1
# Hosts {{{1

hosts=(`tiago-host list`)

# }}}1
# Aliases {{{1

alias lsd='ls -d *(-/DN)'
autoload -Uz zmv # Batch rename (Z move)
alias zmv='noglob zmv'

autoload -Uz zrecompile

# }}}1
# Completion {{{1

zmodload -i zsh/complist

zstyle :compinstall filename "$HOME/.zshrc"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' hosts localhost $hosts
zstyle ':completion:*' users tiago root $USER ${watch/notme/}
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:*:git:*' script ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/git-completion.bash

autoload -Uz compinit
compinit -d ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION

function _tiago()
{
	local cmd=$(basename $words[1])
	if [ "$CURRENT" -eq 2 ]
	then
		local tmp
		tmp=($(grep '^	[a-z-]*[|)]' "$HOME/.local/bin/$cmd" 2> /dev/null | sed -e 's/).*//' | tr '|' ' '))
		_describe -t commands "${words[1]} command" tmp --
	else
		shift words
		(( CURRENT-- ))
		curcontext="${curcontext%:*:*}:$cmd-${words[1]}:"

		local selector=$(grep -E "^	([a-z-]*[|])*${words[1]}([|][a-z-]*)*[)] *# *[_a-z-]*$" "$HOME/.local/bin/$cmd" | sed -e 's/.*# *//')
		_call_function ret _$selector && return $ret

		if [ -n "$selector" ]
		then
			words[1]=$selector
			_normal
		elif [ -f "$HOME/.local/bin/$cmd-${words[1]}" ]
		then
			words[1]=$cmd-${words[1]}
			_tiago
		fi
	fi
}

compdef _tiago tiago

# }}}1
# Keybindings {{{1

bindkey -e
bindkey -r '^Q'

bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^B' backward-char
bindkey -M viins '^D' delete-char-or-list
bindkey -M viins '^E' end-of-line
bindkey -M viins '^F' forward-char
bindkey -M viins '^K' kill-line
bindkey -M viins '^N' down-line-or-history
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M viins '^S' history-incremental-search-forward
bindkey -M viins '^T' transpose-chars
bindkey -M viins '^Y' yank

bindkey -M emacs '^X^[' vi-cmd-mode

bindkey -M emacs ' ' magic-space
bindkey -M viins ' ' magic-space

bindkey -M isearch '^J' accept-search 2> /dev/null

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

autoload -Uz select-word-style
select-word-style bash

change-first-word() {
	zle beginning-of-line -N
	zle kill-word
}
zle -N change-first-word
bindkey -M emacs "\ea" change-first-word

bindkey -M emacs "^XD" describe-key-briefly

fg-widget() {
	if [[ $#BUFFER -eq 0 ]]
	then
		if jobs %- > /dev/null 2>&1
		then
			BUFFER='fg %-'
		else
			BUFFER='fg'
		fi
		zle accept-line
	else
		zle push-input
		zle clear-screen
	fi
}
zle -N fg-widget
bindkey -M emacs "^Z" fg-widget
bindkey -M vicmd "^Z" fg-widget
bindkey -M viins "^Z" fg-widget

autoload -Uz incarg
zle -N incarg
bindkey -M emacs "^X^A" incarg
bindkey -M vicmd "^A" incarg

bindkey -M vicmd ga what-cursor-position

new-screen() {
	[ -z "$STY" ] || screen < "$TTY"
	[ -z "$TMUX" ] || tmux new-window
}
zle -N new-screen
[[ -z "$terminfo[kf12]" ]] || bindkey "$terminfo[kf12]" new-screen

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M emacs '^[e' edit-command-line
bindkey -M emacs '^X^E' edit-command-line
bindkey -M vicmd v edit-command-line

for binding in ${(f)$(bindkey -M emacs|grep '^"\^X')}
do
	bindkey -M viins "${(@Qz)binding}"
done
unset binding

# }}}1

[ ! -r "$HOME/.zshrc.local" ] || . "$HOME/.zshrc.local"
