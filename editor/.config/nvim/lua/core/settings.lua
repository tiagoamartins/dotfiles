local set = vim.opt

-- general {{{1
set.mouse = 'a'     -- allow mouse use for all modes
set.hidden = true   -- allow you to hide buffers with unsaved changes without being prompted
set.encoding = 'utf-8'
set.fileencodings = 'utf-8'

-- backup & swap {{{1
if vim.env.SUDO_USER ~= nil then
    -- don't create root-owned files
    set.backup = false
    set.writebackup = false
else
    local backupdir = vim.env.VIM_TEMP .. '/backup'

    if vim.fn.isdirectory(backupdir) ~= 1 then
        vim.uv.fs_mkdir(backupdir, tonumber('755', 8))
    end
    vim.o.backupdir = backupdir
    set.backup = true       -- keep backup after closing the file
    set.writebackup = true  -- create backup file after overwriting the file
end

-- don't backup files in temp or shared memory directories
if not vim.o.backupskip:lower():find('/tmp/*') then
    -- make sure temp files have no backup (security reason)
    vim.opt.backupskip:append({'/tmp/*'})
end
-- macOS symlinks /var -> /private/var and $TMPDIR is at /var
if vim.loop.os_uname().sysname == 'Darwin' and not vim.o.backupskip:lower():find('/private/var/*') then
    vim.opt.backupskip:append({'/private' .. vim.env.TMPDIR  .. '*'})
end
vim.opt.backupskip:append({'*/shm/*', '*/tmp/*'})

if vim.env.SUDO_USER ~= nil then
    -- don't create root-owned files
    set.swapfile = false
else
    local swapdir = vim.env.VIM_TEMP .. '/swap'
    if vim.fn.isdirectory(swapdir) ~= 1 then
        vim.uv.fs_mkdir(swapdir, tonumber('755', 8))
    end
    vim.o.directory = swapdir .. '//'
    set.swapfile = true
end

-- history {{{1
set.history = 100

if vim.env.SUDO_USER ~= nil then
    -- don't create root-owned files
    set.viminfo = ''
else
    local viminfo = vim.env.VIM_TEMP .. '/viminfo'
    vim.opt.viminfo:append({'n' .. viminfo})
end

-- persist undo tree between sessions
if vim.env.SUDO_USER ~= nil then
    -- don't create root-owned files
    set.undofile = false
else
    local undodir = vim.env.VIM_TEMP .. '/undo'
    if vim.fn.isdirectory(undodir) ~= 1 then
        vim.uv.fs_mkdir(undodir, tonumber('755', 8))
    end
    vim.o.undodir = undodir
    set.undofile = true -- actually use undo files
    set.undolevels = 100
end

local viewdir = vim.env.VIM_TEMP .. '/view'
if vim.fn.isdirectory(viewdir) ~= 1 then
    vim.uv.fs_mkdir(viewdir, tonumber('755', 8))
end
vim.o.viewdir = viewdir
set.viewoptions = {'cursor', 'folds'} -- save/restore just these (with `:{mk,load}view`)

-- UI configuration {{{2
set.number = true           -- enable line numbering, taking up 6 spaces
set.relativenumber = true   -- enable relative line numbering, with the number option set it goes to hybrid mode (Vim 7.4+)
set.cursorline = true       -- highlight the current line
set.lazyredraw = true       -- redraw only when it needs to
set.showmatch = true        -- highlight matching {[()]}
set.wrap = false            -- turn off line wrapping
set.showmode = false        -- remove mode change message
set.laststatus = 2          -- always show status line
set.scrolloff = 3           -- have a number of offset lines (or buffer) when scrolling
set.sidescrolloff = 3       -- same as 'scrolloff', but for columns
set.linebreak = true        -- wrap long lines at characters in 'breakat'
vim.o.showbreak = '∟ '      -- right angle (U+221F, UTF-8: E2 88 9F)

set.colorcolumn = '+1'      -- show column line 1 char after 'textwidth'

set.showcmd = false         -- don't show extra info at end (right) of command line

set.completeopt = {
    'menu',     -- show menu when completing more than one option
    'preview',  -- show extra information about the selected completion
    'noinsert', -- do not auto-insert any text
    'noselect'  -- do not auto-select a match in the menu
}

set.wildmenu = true -- visual autocomplete for command menu
set.wildignore:append({'*.o', '*.rej'}) -- patterns to ignore during file-navigation
set.wildmode = {'longest:full', 'full'} -- shell-like autocomplete to unambiguous portion

-- Symbols for visualization of special characters
set.listchars = {
    eol = '¶',      -- pilcrow sign (U+00B6, UTF-8: C2 B6)
    extends = '»',  -- right-pointing double angle quotation mark (U+00BB, UTF-8: C2 BB)
    nbsp = '○',     -- white circle (U+25CB, UTF-8: E2 97 8B)
    precedes = '«', -- left-pointing double angle quotation mark (U+00AB, UTF-8: C2 AB)
    space = '∙',    -- bullet operator (U+2219, UTF-8: E2 88 99)
    tab = '→ ',     -- rightwards arrow (U+2192, UTF-8: E2 86 92) followed by space
    trail = '•',    -- bullet (U+2022, UTF-8: E2 80 A2)
}

set.shortmess:append({
    A = true, -- ignore annoying swapfile messages
    I = true, -- no splash screen
    O = true, -- file-read message overwrites previous
    T = true, -- truncate non-file messages in middle
    W = true, -- don't echo '[w]'/'[written]' when writing
    a = true, -- use abbreviations in messages eg. '[RO]' instead of '[readonly]'
    o = true, -- overwrite file-written messages
    t = true, -- truncate file messages at start
})

-- spacing {{{1
set.tabstop = 8                             -- set tab character visually to a number of spaces characters
set.softtabstop = 0                         -- number of spaces in tab when editing
set.shiftwidth = 8                          -- indent width for autoindent
set.expandtab = false                       -- don't turn tabs into whitespace
set.shiftround = true                       -- always indent by multiple of shiftwidth
set.smarttab = true                         -- <Tab>/<BS> indent/dedent in leading whitespace
set.backspace = {'indent', 'eol', 'start'}  -- set backspace to be able to delete previous characters
set.textwidth = 0                           -- width necessary to auto split lines

-- searching {{{1
set.incsearch = true    -- search as characters are entered
set.hlsearch = true     -- highlight matches
set.ignorecase = true   -- by default ignore case
set.smartcase = true    -- unless upper case is explicit
set.matchtime = 2       -- tenths of a second to show the matching pattern

-- formatting {{{1
set.smartindent = true  -- turn on smart indent
set.joinspaces = false  -- don't autoinsert two spaces after '.', '?', '!' for join command
set.fileformats = {'unix', 'dos', 'mac'}

set.virtualedit = {'block'} -- allow cursor to move where there is no text in visual block mode
set.whichwrap = {           -- allow <BS>/h/l/<Space>/<Left>/<Right>/~ to cross line boundaries
    b = true,
    s = true,
    ['<'] = true,
    ['>'] = true,
    ['['] = true,
    [']'] = true,
    ['~'] = true,
}

set.formatoptions:append({
    'n',    -- smart auto-indenting inside numbered lists
    'j',    -- remove comment leader when joining comment lines
})

-- folding {{{1
set.fillchars = {
    vert = '┃',   -- Box drawings heavy vertical (U+2503, UTF-8: E2 94 83)
    fold = '·',   -- middle dot (U+00B7, UTF-8: C2 B7)
}

set.foldenable = true       -- enable folding
set.foldmethod = 'marker'   -- enable indent folding
set.foldlevelstart = 99     -- start unfolded

-- windowing {{{1
set.splitbelow = true       -- new splits appear below for horizontal splits
set.splitright = true       -- new splits appear at right for vertical splits
set.bufhidden = 'hide'      -- hide buffer and not unload when not in window (to prevent relogin with FTP edit)
set.switchbuf = 'usetab'    -- try to reuse windows/tabs when switching buffers

-- spelling {{{1
set.spell = false               -- turn spelling off by default
set.spellsuggest = 'best,10'    -- limit it to just the top 10 items
set.spellcapcheck = ''          -- don't check for capital letters at start of sentence
set.complete:append({'kspell'}) -- word completion
set.spelllang = 'en_us'

-- diagnostics {{{1
vim.diagnostic.config({
    virtual_text = true, -- turn on in-line diagnostics
})
