return {
    'vim-test/vim-test',
    cond = function()
        return vim.fn.executable('pytest') == 1
    end,
    cmd = {
        'TestClass',
        'TestFile',
        'TestLast',
        'TestNearest',
        'TestSuite',
        'TestVisit'
    }
}
