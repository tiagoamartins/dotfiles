vim.keymap.set('n', '<f3>', [[<cmd>lua require('dapui').toggle()<cr>]], {})
vim.keymap.set('n', '<f5>', [[<cmd>lua require('dap').continue()<cr>]], {})
vim.keymap.set('n', '<f6>', [[<cmd>lua require('dap').step_over()<cr>]], {})
vim.keymap.set('n', '<f7>', [[<cmd>lua require('dap').step_into()<cr>]], {})
vim.keymap.set('n', '<f8>', [[<cmd>lua require('dap').step_out()<cr>]], {})
