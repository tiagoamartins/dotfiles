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
        *-256color)
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
    print -Pn '%%{$basecolor%%} on %%{$branchcolor%%}%20>..>$ref%<<%%{\e[00m%%}'
}

autoload -Uz colors && colors

local usercolor="$fg_bold[blue]"
local atcolor="$fg_bold[white]"
local hostcolor="$fg_bold[yellow]"
local dircolor="$fg_bold[cyan]"
local hashcolor="$fg_bold[white]"
# Use echotc Co?
case "$TERM" in
    *-256color)
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
    screen*)
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

setopt histexpiredupsfirst histreduceblanks

PERIOD=3600

# }}}1
# Aliases {{{1

alias lsd='ls -d *(-/DN)'

# }}}1
