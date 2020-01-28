" Sends default register to terminal TTY using OSC 52 escape sequence
function! yank#osc52()
    let buffer = system('base64 -w0', @0)
    let buffer = substitute(buffer, '\n$', '', '')
    if &term =~# '^tmux'
        let buffer = '\ePtmux;\e\e]52;c;' . buffer . '\x07\e\x5c'
    elseif &term =~# '^screen'
        let buffer = '\eP\e]52;c;' . buffer . '\x07\e\\'
    else
        let buffer = '\e]52;c;' . buffer . '\x07'
    endif
    silent exe '!echo -ne ' . shellescape(buffer)
endfunction
