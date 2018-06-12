# ~/.zlogout

# Clear screen on logout of the parent terminal session when not in SSH
[ "0$SHLVL" -le 1 -a -z "$SSH_TTY" -a "$TERM" = linux ] && clear
