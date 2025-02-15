return {
    'neovim/nvim-lspconfig',
    event = {'BufReadPre', 'BufNewFile'},
    opts = {
        servers = {
            autotools_ls = {},
            ansiblels = {},
            ['ansible-lint'] = {},
            asm_lsp = {},
            bashls = {},
            clangd = {},
            jsonls = {},
            ltex = {
                settings = {
                    ltex = {
                        enabled = {'latex', 'tex', 'bib', 'markdown'},
                        language = 'en-US',
                        diagnosticSeverity = 'information',
                        setenceCacheSize = 2000,
                        additionalRules = {
                            enablePickyRules = true,
                            motherTongue = 'en',
                        },
                        trace = {server = 'verbose'},
                        dictionary = (function()
                            local files = {}
                            local path = vim.fn.stdpath('config') .. '/spell'
                            for _, file in ipairs(vim.api.nvim_get_runtime_file(path .. '/*', true)) do
                                local lang = vim.fn.fnamemodify(file, ':t:r')
                                local fullpath = vim.fn.fnamemodify(file, ':p')
                                files[lang] = {':' .. fullpath}
                            end

                            if files.default then
                                for lang, _ in pairs(files) do
                                    if lang ~= 'default' then
                                        vim.list_extend(files[lang], files.default)
                                    end
                                end
                                files.default = nil
                            end
                            return files
                        end)(),
                        disabledRules = {
                            ['en-US'] = {'EN_QUOTES', 'WORD_CONTAINS_UNDERSCORE'},
                            ['pt-BR'] = {
                                'ACTUAL',
                                'ATTEND',
                                'FABRIC',
                                'GRATUITY',
                                'NOTICE',
                                'REALIZE',
                                'TURN'
                            }
                        },
                        hiddenFalsePositives = {},
                    }
                }
            },
            marksman = {},
            ruff = {},
            verible = {
                filetypes = {'systemverilog', 'verilog'},
                cmd = {'verible-verilog-ls', '--rules_config_search=true'},
                cmd_match = true,
                root_dir = function() return vim.loop.cwd() end
            },
            veridian = {
                mason = false,
                cmd = {'veridian'},
                cmd_match = true,
                filetypes = {'systemverilog', 'verilog'},
                root_dir = function(fname)
                    local lsp_util = require('lspconfig.util')
                    local lsp_cfgs = require('lspconfig.configs')
                    local root_pattern = lsp_util.root_pattern('veridian.yml', '.git')
                    local filename = fname
                    return root_pattern(filename) or vim.fs.dirname(filename)
                end,
            },
            yamlls = {},
            yamllint = {},
        }
    },
    config = function(_, opts)
        local lspconfig = require('lspconfig')
        local cmp = require('blink.cmp')
        local mason_servers = {}
        local other_servers = {}

        for name, server in pairs(opts.servers) do
            if server.mason == nil or server.mason then
                table.insert(mason_servers, name)
            else
                table.insert(other_servers, name)
            end
        end

        require('plugins.lsp.mappings').map()

        function register_lsp(server_name)
            local server = opts.servers[server_name] or {}
            local cmd = (server.cmd or {})[1] or server_name
            local skip_match = server.cmd_match == nil or not server.cmd_match

            if vim.fn.executable(cmd) == 1 or skip_match then
                server.capabilities = cmp.get_lsp_capabilities(server.capabilities)
                lspconfig[server_name].setup(server)
            end
        end

        for _, name in ipairs(other_servers) do
            register_lsp(name)
        end

        require('mason-tool-installer').setup({
            ensure_installed = mason_servers
        })

        require('mason-lspconfig').setup({
            handlers = {register_lsp}
        })
    end
}
