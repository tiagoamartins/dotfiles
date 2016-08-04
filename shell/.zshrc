# ~/.zshrc
# vim:set et sw=4:

# External {{{1

[ ! -r "$HOME/.shrc" ] || . "$HOME/.shrc"

# }}}1
# Prompt {{{1

_repo_prompt_info() {
    case "$PWD" in
        /net/*|/Volumes/*) return ;;
    esac
    if [ -d .svn ]; then
        ref=.svn
    elif [ -d .hg ]; then
        ref=${$(hg branch 2> /dev/null)} || \
            return
    else
        ref=${$(git symbolic-ref HEAD 2> /dev/null)#refs/heads/} || \
            ref=${$(git rev-parse HEAD 2> /dev/null)[1][1,7]} || \
            return
    fi
    case "$TERM" in
        *-256color|tmux)
            basecolor=$'\e[1;38;5;244m'
            branchcolor=$'\e[1;38;5;136m'
            ;;
        *-88color|rxvt-unicode)
            basecolor=$'\e[1;38;5;83m'
            branchcolor=$'\e[1;38;5;72m'
            ;;
        xterm*)
            basecolor=$'\e[01;37m'
            branchcolor=$'\e[01;37m'
            ;;
        *)
            basecolor="$fg_bold[white]"
            branchcolor="$fg_bold[white]"
            ;;
    esac
    print -Pn '%%{$basecolor%%}[%%{$branchcolor%%}%20>..>$ref%<<%%{$basecolor%%}]%%{\e[00m%%}'
}

autoload -Uz colors && colors

local usercolor="$fg_bold[blue]"
local atcolor="$fg_bold[white]"
local hostcolor="$fg_bold[yellow]"
local dircolor="$fg_bold[cyan]"
local hashcolor="$fg_bold[white]"
# Use echotc Co?
case "$TERM" in
    *-256color|tmux)
        usercolor=$'\e[1;38;5;33m'
        atcolor=$'\e[1;38;5;136m'
        hostcolor=$'\e[1;38;5;166m'
        dircolor=$'\e[1;38;5;37m'
        hashcolor=$'\e[1;38;5;231m'
        ;;
    *-88color|rxvt-unicode)
        usercolor=$'\e[1;38;5;23m'
        atcolor=$'\e[1;38;5;72m'
        hostcolor=$'\e[1;38;5;68m'
        dircolor=$'\e[1;38;5;26m'
        hashcolor=$'\e[1;38;5;79m'
        ;;
esac
[ $UID = '0' ] && usercolor="$fg_bold[red]"
reset_color=$'\e[00m'

PROMPT="%{$usercolor%}%n%{$atcolor%}@%{${hostcolor}%}%m%{$hashcolor%}:%{$dircolor%}%30<...<%~%<<%{$reset_color%}\$(_repo_prompt_info) %{$hashcolor%}%# %{$reset_color%}"
RPS1="%(?..(%{"$'\e[01;35m'"%}%?%{$reset_color%}%)%<<)"
setopt promptsubst

_set_title() {
    case "$1" in
        *install*)
            hash -r ;;
    esac
    print -Pn '\e]1;%l@%m${1+*}\a'
    print -Pn '\e]2;%n@%m:%~'
    if [ -n "$1" ]; then
        print -Pnr ' (%24>..>$1%>>)'|tr '\0-\037' '?'
    fi
    print -Pn " [%l]\a"
}

case $TERM in
    screen*|tmux*)
        PROMPT="${PROMPT//01;3/00;9}"
        precmd() {
            _set_title "$@"
            if [ "$STY" -o "$TMUX" ]; then
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
            if [ "$STY" -o "$TMUX" ]; then
                print -Pn '@\e\\'
            else
                print -Pn '@%m\e\\'
            fi
        }
        ;;

    xterm*|rxvt*|Eterm*|kterm*|putty*|dtterm*|ansi*|cygwin*)
        PROMPT="${PROMPT//01;3/00;9}"
        precmd () { _set_title "$@" }
        preexec() { _set_title "$@" }
        ;;

    linux*|vt220*) ;;

    *)
        PS1="%n@%m:%~%# "
        RPS1="%(?..(%?%)%<<)"
        ;;
esac

unset hostcolor dircolor usercolor atcolor hashcolor reset_color

# Options {{{1

setopt rmstarsilent histignoredups
setopt nonomatch
setopt completeinword extendedglob
setopt autocd cdable_vars

HISTSIZE=100

if [[ $ZSH_VERSION == 3.<->* ]]; then
    which zmodload >& /dev/null && zmodload zsh/compctl
    compctl -c sudo
    compctl -c which
    compctl -g '*(-/)' + -g '.*(-/)' -v cd pushd rmdir
    compctl -k hosts -x 'p[2,-1]' -l '' -- rsh ssh
    return 0
fi

setopt histexpiredupsfirst histreduceblanks

fpath=($fpath ~/.zsh/functions ~/.zsh/functions.zwc)
watch=notme
PERIOD=3600
periodic() { rehash }

# }}}1
# Aliases {{{1

alias lsd='ls -d *(-/DN)'
autoload -Uz zmv # Batch rename (Z move)
alias zmv='noglob zmv'

autoload -Uz zrecompile

# }}}1
# Completion {{{1

zmodload -i zsh/complist

# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

compdef _tiago tiago

_tiago() {
    local cmd=$(basename $words[1])
    if [[ $CURRENT = 2 ]]; then
        local tmp
        tmp=($(grep '^    [a-z-]*[|)]' "$HOME/.local/bin/$cmd" 2>/dev/null | sed -e 's/).*//' | tr '|' ' '))
        _describe -t commands "${words[1]} command" tmp --
    else

        shift words
        (( CURRENT-- ))
        curcontext="${curcontext%:*:*}:$cmd-${words[1]}:"

        local selector=$(egrep "^    ([a-z-]*[|])*${words[1]}([|][a-z-]*)*[)] *# *[_a-z-]*$" "$HOME/.local/bin/$cmd" | sed -e 's/.*# *//')

        if [[ -f "$HOME/.local/bin/$cmd-${words[1]}" ]]; then
            words[1]="$cmd-${words[1]}"
            _tiago
        elif (( $+functions[_${selector-$words[1]}] )); then
            service=${selector-$words[1]}
            _call_function ret _$service && return $ret
        else
            _normal
        fi
    fi
}

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

bindkey -M isearch '^J' accept-search 2>/dev/null

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
    if [[ $#BUFFER -eq 0 ]]; then
        if jobs %- >/dev/null 2>&1; then
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
bindkey -M emacs '^[e'  edit-command-line
bindkey -M emacs '^X^E' edit-command-line
bindkey -M vicmd v      edit-command-line

for binding in ${(f)$(bindkey -M emacs|grep '^"\^X')}; do
    bindkey -M viins "${(@Qz)binding}"
done
unset binding

# }}}1
