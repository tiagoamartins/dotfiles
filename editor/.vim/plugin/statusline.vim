if exists('g:loaded_statusline')
    finish
endif
let g:loaded_statusline = 1

let s:white       = {'gui': '#c6c6c6', 'cterm': '251'}
let s:grey234     = {'gui': '#1c1c1c', 'cterm': '234'}
let s:green       = {'gui': '#b5bd68', 'cterm': '10'}
let s:blue        = {'gui': '#81a2be', 'cterm': '12'}
let s:purple      = {'gui': '#b294bb', 'cterm': '13'}
let s:red         = {'gui': '#cc6666', 'cterm': '9'}
let s:orange      = {'gui': '#de935f', 'cterm': '3'}
let s:fallback_bg = {'gui': '#303030', 'cterm': '236'}

function! s:SetColors(gname, bg, fg) abort
    exec 'highlight ' . a:gname
                \ . ' ctermbg=' . a:bg.cterm . ' ctermfg=' . a:fg.cterm
                \ . ' guibg=' . a:bg.gui . ' guifg=' . a:fg.gui
endfunction

function! s:StatusLine(active) abort
    if &buftype ==# 'nofile' || &filetype ==# 'netrw'
        " probably a file explorer
        setlocal statusline=%!statusline#NoFileStatusLine()
    elseif &buftype ==# 'nowrite'
        " no custom status line for special windows
        return
    elseif a:active == 1
        setlocal statusline=%!statusline#ActiveStatusLine()
    else
        setlocal statusline=%!statusline#InactiveStatusLine()
    endif
endfunction

" Update the status line for all inactive windows
"
" This is needed when starting Vim with multiple splits, for example 'vim -O
" file1 file2', otherwise all 'status lines will be rendered as if they are
" active. Inactive statuslines are usually rendered via the WinLeave and
" BufLeave events, but those events are not triggered when starting Vim.
"
" Note - https://jip.dev/posts/a-simpler-vim-statusline/#inactive-statuslines
function! s:UpdateInactiveWindows() abort
    for winnum in range(1, winnr('$'))
        if winnum != winnr()
            call setwinvar(winnum, '&statusline', '%!statusline#InactiveStatusLine()')
        endif
    endfor
endfunction

function! s:UserColors() abort
    let l:bg = {'gui': '', 'cterm': ''}

    " Leverage existing 'colorscheme' StatusLine colors taking into account
    " the 'reverse' option.
    if synIDattr(synIDtrans(hlID('StatusLine')), 'reverse', 'cterm') == 1
        let l:bg.cterm = synIDattr(synIDtrans(hlID('StatusLine')), 'fg', 'cterm')
    else
        let l:bg.cterm = synIDattr(synIDtrans(hlID('StatusLine')), 'bg', 'cterm')
    endif

    if synIDattr(synIDtrans(hlID('StatusLine')), 'reverse', 'gui') == 1
        let l:bg.gui = synIDattr(synIDtrans(hlID('StatusLine')), 'fg', 'gui')
    else
        let l:bg.gui = synIDattr(synIDtrans(hlID('StatusLine')), 'bg', 'gui')
    endif

    " Fallback to statusline colors when the current color scheme does not
    " define StatusLine colors.
    if len(l:bg.cterm) == 0
        let l:bg.cterm = s:fallback_bg.cterm
    endif
    if len(l:bg.gui) == 0
        let l:bg.gui = s:fallback_bg.gui
    endif

    " Set user colors that will be used to color certain sections of the
    " status line.
    call s:SetColors('User1', s:blue, s:grey234)
    call s:SetColors('User2', s:green, s:grey234)
    call s:SetColors('User3', s:purple, s:grey234)
    call s:SetColors('User4', s:red, s:grey234)
    call s:SetColors('User5', l:bg, s:blue)
    call s:SetColors('User6', l:bg, s:green)
    call s:SetColors('User7', s:purple, s:grey234)
    call s:SetColors('User8', l:bg, s:orange)
    call s:SetColors('User9', s:red, s:grey234)
endfunction

augroup MyStatuslineEvents
    autocmd!
    autocmd CursorHold,BufWritePost * unlet! b:statusline_whitespace_warning
    autocmd VimEnter * call s:UpdateInactiveWindows()
    autocmd ColorScheme,SourcePre * call s:UserColors()
    autocmd WinEnter,BufWinEnter * call s:StatusLine(1)
    autocmd WinLeave * call s:StatusLine(0)
    if exists('##CmdlineEnter')
        autocmd CmdlineEnter * call s:StatusLine(1) | redraw
    endif
augroup END
