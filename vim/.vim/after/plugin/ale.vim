let g:ale_sign_error = 'X'
let g:ale_sign_warning = 'Δ'

let g:ale_python_flake8_options='--ignore=W503'
let g:ale_c_gcc_options='-std=gnu11 -Wall'

let g:ale_linters = {
            \   'cpp': ['gcc']
            \}

autocmd User ProjectionistActivate call s:activate()
function! s:activate() abort
    for [root, value] in projectionist#query('cflags')
        let b:ale_c_gcc_options = value
        let b:ale_cpp_gcc_options = value
        break
    endfor
endfunction

autocmd FileType vhdl call s:set_simulation_dir()
function! s:set_simulation_dir() abort
    if exists('b:projectionist') && !empty('b:projectionist')
        for [root, value] in projectionist#query('simulation')
            let sim_dir = '"' . expand(root . '/' . value) . '"'
            break
        endfor
    elseif isdirectory('work')
        let sim_dir = 'work'
    endif

    if exists('sim_dir')
        let b:ale_vhdl_vcom_options = '-2008 -work ' . sim_dir
        let b:ale_vhdl_ghdl_options = '--std=08 --workdir=' . sim_dir
    endif
endfunction
