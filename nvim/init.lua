vim.g.mapleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("k.plugins")

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

vim.opt.clipboard = 'unnamedplus'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.hidden = true


vim.o.autowrite = true
vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
  pattern = "*",
  command = "silent! write"
})
		

-- Correcting the nnoremap statements
vim.api.nvim_set_keymap('n', '<C-U>', '<C-U>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-D>', '<C-D>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-]>', '<C-]>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-o>', '<C-o>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-i>', '<C-i>zz', { noremap = true })

-- nvim-tree binds 
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })

-- Pour naviguer vers les fonctions/symboles dans le fichier actuel
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope lsp_document_symbols<CR>', { noremap = true, silent = true })

-- Pour chercher des fonctions dans tout le projet
vim.keymap.set('n', '<leader>fS', '<cmd>Telescope lsp_workspace_symbols<CR>', { noremap = true, silent = true })

-- telescope binds
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "html",
  callback = function()
    vim.opt_local.autoindent = false
    vim.opt_local.smartindent = false
    vim.opt_local.indentexpr = ""
  end
})

