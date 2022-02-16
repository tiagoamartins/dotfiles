" VHDL filetype plugin
" Language:    VHDL
" Maintainer:  Tiago Martins
" Last Change: 2016 Jan 10

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Add filters to Windows browse dialog window.
if has("gui_win32") && !exists("b:browsefilter")
    let b:browsefilter = "VHDL Source Files (*.vhd)\t*.vhd\n" .
                       \ "All Files (*.*)\t*.*\n"
endif

" List of keywords that use end as keyword terminator
let s:vhdlStructures   = ['package', 'entity', 'architecture', 'configuration']
let s:vhdlMainKeywords = ['process', 'block', 'function', 'procedure', 'generate', 'component'] + s:vhdlStructures
let s:vhdlKeywords     = ['loop', 'record', 'units'] + s:vhdlMainKeywords

" Comment Formatting {{{1

" Change how comments are formatted:
" c - Auto-wrap using 'textwidth'.
" r - Insert comment leader when hitting <CR>.
" o - Insert comment leader when hitting 'o' or 'O'.
" q - Allow formatting with 'gq'
" l - Long lines are not broken in insert mode.
" m - Break at multi-byte character.
" 1 - Don't break after one-letter word.
setlocal formatoptions+=croqlm1

" Set up comments, both VHDL-87 and VHDL-2008 multi-line
setlocal comments=:--\ ,:--!\ ,sr:/*,mb:*,ex:*/
setlocal commentstring=--\ %s

" }}}1
" Section Motion {{{1

function! <SID>NextVhdlSection(type, backward, visual)

    " No wrap arround during search
    let flags = 'W'

    if a:type == 1
        let keywordList = s:vhdlMainKeywords
    elseif a:type == 2
        let keywordList = s:vhdlStructures
    endif

    let pattern = '\c\%(\%(^\|\;\)\s*\%(\w\+\:\s*\)\?\)\@<=\<\%(' . join(keywordList, '\|') . '\)\>'

    if a:backward
        let pattern .= '\|\%^'
        let flags .= 'b'
    else
        let pattern .= '\|\%$'
    endif

    " Obtain lost selection due to function call
    if a:visual
        normal! gv
    endif

    call search(pattern, flags)
endfunction

" Motion mappings
noremap  <script> <buffer> <silent> ]] :<C-u>call <SID>NextVhdlSection(1, 0, 0)<CR>
noremap  <script> <buffer> <silent> [[ :<C-u>call <SID>NextVhdlSection(1, 1, 0)<CR>
noremap  <script> <buffer> <silent> ][ :<C-u>call <SID>NextVhdlSection(2, 0, 0)<CR>
noremap  <script> <buffer> <silent> [] :<C-u>call <SID>NextVhdlSection(2, 1, 0)<CR>
vnoremap <script> <buffer> <silent> ]] :<C-u>call <SID>NextVhdlSection(1, 0, 1)<CR>
vnoremap <script> <buffer> <silent> [[ :<C-u>call <SID>NextVhdlSection(1, 1, 1)<CR>
vnoremap <script> <buffer> <silent> ][ :<C-u>call <SID>NextVhdlSection(2, 0, 1)<CR>
vnoremap <script> <buffer> <silent> [] :<C-u>call <SID>NextVhdlSection(2, 1, 1)<CR>

" }}}1
" Folding {{{1

function! GetLineWithText(lnum)
    let lineNum = a:lnum
    let lineText = getline(lineNum)

    while lineText !~? '^\s*\%(--\W*\)\?\w\+'
        let lineNum += 1
        let lineText = getline(lineNum)
    endwhile

    return lineText
endfunction

function! GetNextNonComment(lnum)
    let lineNum = a:lnum
    let lineText = getline(lineNum)

    while lineText =~? '^\s*--.*'
        let lineNum += 1
        let lineText = getline(lineNum)
    endwhile

    return lineText
endfunction

function! GetVhdlFold(lnum)
    let lineNum = a:lnum
    let currLine = getline(lineNum)
    let keywordList = join(s:vhdlMainKeywords, '\|')

    if currLine =~? '\c\%(^\s*\)\@<=\<end\s\+\%(' . keywordList . '\)\>'
        " Close any fold if there's an end keyword in the current line.
        return 's1'
    else
        let prevLine = getline(lineNum - 1)

        if prevLine =~? '^\s*--.*'
            " If previous line is a comment and current line hasn't an end keyword
            " then assume the same fold.
            return '='
        elseif currLine =~? '^\s*--.*'
            " Move the fold to the first comment line that precede a fold.
            let nextLine = GetNextNonComment(lineNum)
        else
            " For no comment block fold following code rules.
            let nextLine = currLine
        endif

        if nextLine =~? '\c\%(^\s*\%(\w\+\:\s*\)\?\)\@<=\<\%(' . keywordList . '\)\>'
            " For a line of code that has the selected keywords open a fold.
            return 'a1'
        else
            " For any other line just assume same the fold.
            return '='
        endif
    endif
endfunction

function! GetVhdlFoldText(start, end, dashes)
    let lineNum = a:start
    let lineCount = a:end - a:start + 1

    if lineCount == 1
        let plural = ''
    else
        let plural = 's'
    endif

    let header = '+-' . a:dashes . ' ' . lineCount . ' line' . plural . ': '
    let line = GetLineWithText(lineNum)
    let lineSub = substitute(line, '^\s\+\|\%(--!\?\s*\)\|\s\+$', '', 'g')

    return header . lineSub . ' '
endfunction

setlocal foldmethod=expr
setlocal foldexpr=GetVhdlFold(v:lnum)
setlocal foldtext=GetVhdlFoldText(v:foldstart,v:foldend,v:folddashes)

" }}}1
" External Plugins {{{1
" Matchit {{{2

" Add matchit plugin new words.
if exists("loaded_matchit")  && ! exists("b:match_words")
    function! <SID>GetVhdlMatchWords()
        let s:notend = '\%(\<end\s\+\)\@<!'
        " Exceptions
        let l:vhdlMatches =
            \ s:notend . '\<if\>:\<elsif\>:\<else\>:\<end\s\+if\>,' .
            \ s:notend . '\<case\>:\<when\>:\<end\s\+case\>,' .
            \ s:notend . '\<for\>:\<end\s\+loop\>,' .
            \ s:notend . '\<while\>:\<end\s\+loop\>'

        " General case
        for l:keyword in s:vhdlKeywords
            let l:vhdlMatches .= ',' . s:notend . '\<' . l:keyword . '\>:\<end\s\+' . l:keyword . '\>'
        endfor

        return l:vhdlMatches
    endfunction

    let b:match_ignorecase = 1
    let b:match_words = <SID>GetVhdlMatchWords()
endif

" }}}2
" }}}1

let &cpo = s:cpo_save
unlet s:cpo_save
