let g:projectionist_heuristics = {
            \   '*.c': {
            \       'type': 'source',
            \       'alternate': '{}.h'
            \   },
            \   '*.h': {
            \       'type': 'header',
            \       'alternate': '{}.c'
            \   },
            \   '*.py': {
            \       'type': 'source',
            \       'alternate': 'tests/{dirname}/test_{basename}.py'
            \   },
            \   'test/**/test_*.py': {
            \       'type': 'test',
            \       'alternate': '{dirname}/{basename}.py'
            \   }
            \}
