return {
    cmd = {'verible-verilog-ls', '--rules_config_search=true'},
    filetypes = {
        'systemverilog',
        'verilog',
    },
    root_markers = {
        '.git',
        '.rules.verible_lint',
        'verible.filelist',
    },
}
