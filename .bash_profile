# ~/.bash_profile

[ ! -r "$HOME/.profile" ] || . "$HOME/.profile"
[[ $- != *i* ]] || . "$HOME/.bashrc"
