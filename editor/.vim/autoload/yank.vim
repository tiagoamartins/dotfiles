" Sends default register to terminal TTY using OSC 52 escape sequence
function! yank#osc52(text) abort
    let buffer = system('yank', a:text)
    if v:shell_error
        echoerr buffer
    endif
endfunction
