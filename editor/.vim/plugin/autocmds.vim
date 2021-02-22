if has('autocmd')
    " Make sure Vim returns to the same line when you reopen a file.
    augroup line_return
        autocmd!
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \     execute 'normal! g`"zvzz' |
                    \ endif
    augroup END

    " Don't keep swap files in temp or shared memory directories
    augroup swapskip
        autocmd!
        silent! autocmd BufNewFile,BufReadPre
                    \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
                    \ setlocal noswapfile
    augroup END

    " Don't keep undo files in temp or shared memory directories
    if has('persistent_undo')
        augroup undoskip
            autocmd!
            silent! autocmd BufWritePre
                        \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
                        \ setlocal noundofile
        augroup END
    endif

    " Don't create viminfo temp or shared memory directories
    if has('viminfo')
        augroup viminfoskip
            autocmd!
            silent! autocmd BufNewFile,BufReadPre
                        \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
                        \ setlocal viminfo=
        augroup END
    endif

    " Automatically call OSC52 function on yank to sync register with host clipboard
    if exists('##TextYankPost')
        augroup yank
            autocmd!
            autocmd TextYankPost *
                        \ if v:event.operator ==# 'y' && v:event.regname ==# '+' |
                        \     call yank#osc52(v:event.regcontents) |
                        \ endif
        augroup END
    endif
endif
