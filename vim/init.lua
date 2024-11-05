
-- Enable filetype detection
vim.cmd("filetype on")

vim.g.mapleader = ','
vim.g.maplocalleader = ‘,’

-- Encoding settings
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "utf-8" }
vim.opt.bomb = true
vim.opt.binary = true
vim.opt.ttyfast = true
vim.opt.fileformats = { "unix", "dos", "mac" }

-- Appearance settings
vim.opt.termguicolors = true -- Equivalent to setting t_Co=256
if vim.opt.termguicolors:get() then
    vim.cmd("syntax on")
end
vim.opt.number = true -- Show line numbers
vim.opt.showcmd = true      -- Show command in bottom bar
-- vim.opt.cursorline = true -- Uncomment to enable cursor line highlight
vim.opt.wildmenu = true     -- Visual autocomplete for command menu
vim.opt.lazyredraw = true   -- Redraw only when needed
-- displays the current cursor position (line and column number) in the status line at the bottom right of the window
vim.opt.ruler = true
-- vim.opt.colorcolumn = "120" -- Uncomment if you want a fixed color column
vim.cmd([[call matchadd("ColorColumn", '\%121v', 80)]])
vim.cmd([[call matchadd("ColorColumn", '\%121v', 120)]])
vim.cmd("highlight ColorColumn ctermbg=8 guibg=lightgrey")
vim.cmd("highlight LineNr ctermfg=grey")
vim.cmd("highlight CursorLine ctermbg=LightBlue")

-- Split window settings
vim.opt.splitright = true

-- Remember the cursor position of the last opened file
if vim.fn.has("autocmd") == 1 then
  vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    command = [[if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]],
  })
end

-- Change cursor shape for insert and normal mode in terminal and tmux
if vim.env.TMUX then
  -- vim.opt.t_SI = "\27Ptmux;\27\27]50;CursorShape=1\x7\27\\"
  -- vim.opt.t_EI = "\27Ptmux;\27\27]50;CursorShape=0\x7\27\\"
  -- vim.opt.t_SI = "\\ePtmux;\\e\\e[50;CursorShape=1\\x7\\e\\"
  -- vim.opt.t_EI = "\\ePtmux;\\e\\e[50;CursorShape=0\\x7\\e\\"
else
  -- vim.opt.t_SI = "\27]50;CursorShape=1\x7"
  -- vim.opt.t_EI = "\27]50;CursorShape=0\x7"
  -- vim.opt.t_SI = "\\e[50;CursorShape=1\\x7"
  -- vim.opt.t_EI = "\\e[50;CursorShape=0\\x7"
end

-- Tab and indentation settings
vim.opt.wrap = false
vim.opt.tabstop = 4         -- A tab is four spaces
vim.opt.softtabstop = 4     -- Pretend like a tab is removed when hitting <BS>, even if spaces
vim.opt.shiftwidth = 4      -- Number of spaces to use for auto-indenting
vim.opt.autoindent = true   -- Always set auto-indenting on
vim.opt.fileformat = "unix" -- Use Unix line endings

-- Specific tab settings for different file types
vim.api.nvim_create_augroup("TabSettingFor2SpacesAsTab", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "vim", "javascript", "typescript", "vue", "jsx", "css", "html", "yaml", "yml", "sql", "proto" },
  group = "TabSettingFor2SpacesAsTab",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true
    vim.bo.textwidth = 120
  end,
})

vim.api.nvim_create_augroup("TabSettingForPython", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  group = "TabSettingForPython",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.textwidth = 120
  end,
})

vim.api.nvim_create_augroup("TabSettingForGo", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  group = "TabSettingForGo",
  callback = function()
    vim.bo.expandtab = false
    vim.bo.textwidth = 120
  end,
})

-- Set custom filetype for shell.rc files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "shell.rc",
  command = "set filetype=zsh",
})


-- If you have specific extensions for binary files (such as exe, bin, etc.),
-- you may want to automate the process of editing them in binary (xxd) format.
-- Change "*.bin" to a comma-separated list of extensions you frequently edit.

vim.api.nvim_create_augroup("Binary", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = "*.bin",
  group = "Binary",
  callback = function() vim.bo.binary = true end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.bin",
  group = "Binary",
  callback = function()
    if vim.bo.binary then
      vim.cmd("%!xxd")
      vim.bo.filetype = "xxd"
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.bin",
  group = "Binary",
  callback = function()
    if vim.bo.binary then
      vim.cmd("%!xxd -r")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.bin",
  group = "Binary",
  callback = function()
    if vim.bo.binary then
      vim.cmd("%!xxd")
      vim.bo.modified = false
    end
  end,
})

-- Folding settings
vim.opt.foldenable = true         -- Enable folding
-- vim.opt.foldlevelstart = 1      -- Open most folds by default
-- vim.opt.foldmethod = "indent"   -- Uncomment to set fold method to indent
-- vim.opt.foldmethod = "syntax"   -- Uncomment to use syntax folding (may be slow for large files)
-- vim.opt.foldlevel = 1           -- Uncomment to start with folds mostly closed

-- Search settings
vim.opt.showmatch = true          -- Highlight matching parentheses
vim.opt.hlsearch = true           -- Highlight all search results
vim.api.nvim_set_keymap("n", "<leader><space>", ":noh<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<silent> <Esc>", ":nohlsearch<Bar>:echo<CR>", { noremap = true, silent = true })

-- Miscellaneous settings
vim.opt.history = 10000           -- Increase command history size

-- Disable mouse
vim.opt.mouse = ""

-- Clipboard settings
-- Paste without overwriting the clipboard
vim.api.nvim_set_keymap("x", "<leader>p", '"_dP', { noremap = true, silent = true })

-- Python breakpoint
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.py",
  callback = function()
    vim.api.nvim_set_keymap("n", "<leader>b", "oimport pdb; pdb.set_trace()  # XXX BREAKPOINT<Esc>", { noremap = true, silent = true })
  end,
})

-- Enable 24-bit true color
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
  -- vim.opt.t_8f = "\27[38;2;%lu;%lu;%lum"  -- Foreground color
  -- vim.opt.t_8b = "\27[48;2;%lu;%lu;%lum"  -- Background color
end

-- Enable italics
-- vim.opt.t_ZH = "\27[3m"  -- Start italics
-- vim.opt.t_ZR = "\27[23m" -- End italics

-- Line number settings
vim.opt.number = true              -- Show absolute line numbers
vim.opt.relativenumber = true      -- Show relative line numbers

-- Toggle hybrid line numbers (command examples, uncomment as needed)
-- vim.opt.number = not vim.opt.number:get()
-- vim.opt.relativenumber = not vim.opt.relativenumber:get()

-- Highlight the current line
vim.opt.cursorline = true

-- Spell check settings
-- Highlights spelling errors; press `z=` for suggestions, `zg` to add to dictionary
vim.opt.spell = true
vim.opt.spelllang = { "en" }
vim.opt.spellfile = { "~/.vim/spell/en.utf-8.add", "~/.sword/vim/spell/en.utf-8.add" }

require("config.lazy")

-- references
-- https://neovim.io/doc/user/usr_06.html

