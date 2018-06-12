# ~/.bash_profile

# Load .profile if available
[ ! -r "$HOME/.profile" ] || . "$HOME/.profile"

# Load .bashrc if bash is running in *interactive mode*
[[ $- != *i* ]] || . "$HOME/.bashrc"
