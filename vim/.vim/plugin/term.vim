if has('termguicolors')
    " Don't need this in xterm-256color, but do need it inside tmux.
    " (See `:h xterm-true-color`.)
    if &term =~# '^tmux' || &term =~# '^screen'
        let &t_8f="\<Esc>[38:2:%lu:%lu:%lum"
        let &t_8b="\<Esc>[48:2:%lu:%lu:%lum"
    endif
endif
