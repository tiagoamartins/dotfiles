return {
    cmd = {
        'verible-verilog-ls',
        '--rules_config_search=true',
        '--lsp_enable_hover',
    },
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
