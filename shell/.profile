# ~/.profile

# Set the default path for commands
PATH=$HOME/.local/bin:/usr/local/bin:${PATH:-/usr/bin:/bin}:/usr/sbin:/sbin
# Set shell startup file when in POSIX mode
ENV=$HOME/.shrc
# Set bash scripts startup file
BASH_ENV=$HOME/.zshenv
# Set SSH as rsync shell transporter without agent (-a) nor X11 (-x) forwarding
[ -n "$RSYNC_RSH" ] || RSYNC_RSH='ssh -ax'
export PATH ENV BASH_ENV RSYNC_RSH

# Export all variables defined locally
if [ -r "$HOME/.env.local" ]
then
	eval "`command grep '^[A-Z].*=' "$HOME/.env.local" | sed -e 's/^/export /'`"
fi

# Less as default pager
if [ -z "$PAGER" ] && type less > /dev/null 2>&1
then
	PAGER=less
	export PAGER
fi

# Less options:
# -F   exit less if content fit on the first screen
# -R   output only color as "raw" commands to the screen
# -X   avoid clearing the screen after exit
# -#10 shift 10 columns when using left and right arrows
LESS="-RFX#10"
if [ -z "$LESSOPEN" ] && type lesspipe.sh > /dev/null 2>&1
then
	LESSOPEN='| lesspipe.sh %s'
elif [ -z "$LESSOPEN" ]
then
	LESSOPEN='| "$HOME/.lessfilter" %s'
fi

# Set default editor as nvim
if type nvim > /dev/null 2>&1
then
	VISUAL=nvim
elif type vim > /dev/null 2>&1
then
	VISUAL=vim
else
	VISUAL=vi
fi
EDITOR=$VISUAL
export LESS LESSOPEN VISUAL EDITOR

export COLORFGBG="15;0"

# Set word split for Zsh
[ -z "$ZSH_VERSION" ] || setopt shwordsplit

# Validate and append directories in PATH variable
IFS=:
newpath=$HOME/.local/bin
for dir in $PATHPREPEND $PATH
do
	case :$newpath: in
		*:$dir:*) ;;
		*) [ -z "$dir" -o ! -d "$dir" ] || newpath=$newpath:$dir;;
	esac
done
PATH=$newpath

# Cleanup local variables
unset IFS dir newpath
[ -z "$ZSH_VERSION" ] || setopt noshwordsplit

# Source local profile file
[ ! -r "$HOME/.profile.local" ] || . "$HOME/.profile.local"
