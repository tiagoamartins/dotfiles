# ~/.bash_logout

[ ! -r "$HOME/.zlogout" ] || . "$HOME/.zlogout"

# source local bash_logout file if it exists
[ ! -r "$HOME/.bash_logout.local" ] || . "$HOME/.bash_logout.local"
