# ~/.profile

# Set the default path for commands
PATH=$HOME/.local/bin:/usr/local/bin:${PATH:-/usr/bin:/bin}:/usr/sbin:/sbin
# Set shell startup file when in POSIX mode
ENV=$HOME/.shrc
export PATH ENV

# Export all variables defined locally
if [ -r "$HOME/.env.local" ]; then
    eval "`command grep '^[A-Z].*=' "$HOME/.env.local"|sed -e 's/^/export /'`"
fi

# Source local profile file
[ ! -r "$HOME/.profile.local" ] || . "$HOME/.profile.local"

# Less as default pager
if [ -z "$PAGER" ] && type less >/dev/null 2>&1; then
    PAGER=less
    export PAGER
fi
LESS="FRX#10"
if [ -z "$LESSOPEN" ] && type lesspipe >/dev/null 2>&1; then
    LESSOPEN='|lesspipe %s'
elif [ -z "$LESSOPEN" ]; then
    LESSOPEN='|"$HOME/.lessfilter" %s'
fi
# Set default editor as vim
if [ -z "$VISUAL" ]; then
    type vim >/dev/null 2>&1 && VISUAL=vim || VISUAL=vi
fi
EDITOR=$VISUAL
export LESS LESSOPEN VISUAL EDITOR

# Validate and append directories in PATH variable
IFS=:
newpath=$HOME/.local/bin
for dir in $PATHPREPEND $PATH; do
    case :$newpath: in
        *:$dir:*) ;;
        *) [ -z "$dir" -o ! -d "$dir" ] || newpath=$newpath:$dir ;;
    esac
done
PATH=$newpath

# Cleanup local variables
unset IFS dir newpath
