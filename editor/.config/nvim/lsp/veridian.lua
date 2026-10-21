-- verible (lsp/verible.lua) owns SystemVerilog formatting
return {
    cmd = {'veridian'},
    filetypes = {
        'systemverilog',
        'verilog',
    },
    root_markers = {
        '.git',
        'veridian.yml',
    },
    server_capabilities = {
        documentFormattingProvider = vim.NIL,
        documentRangeFormattingProvider = vim.NIL,
    },
}
