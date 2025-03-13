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
            harper_ls = {},
            jsonls = {},
            lua_ls = {},
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

        require('config.lsp-mappings').map()

        local function register_lsp(server_name)
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
    end,
}
