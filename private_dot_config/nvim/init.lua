vim.g.mapleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("k.plugins")

vim.o.background = "light"
pcall(vim.cmd, "colorscheme gruvbox")

vim.opt.clipboard = 'unnamedplus'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.hidden = true
vim.o.autowrite = true
vim.o.winborder = "rounded"
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = false
vim.opt.preserveindent = true
vim.opt.copyindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true

-- vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
--   pattern = "*",
--   callback = function()
--     if vim.bo.buftype == "" and vim.bo.modifiable and vim.fn.expand("%") ~= "" then
--       vim.cmd("silent! update")
--     end
--   end,
-- })

-- ouvre infos lsp
vim.keymap.set('n', '<S-k>', vim.lsp.buf.hover)

--speed key
vim.keymap.set('n', '<leader>r', ':update<CR> :make<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')

-- Swap ; et : pour éviter le Shift (plus ergonomique)
vim.keymap.set({ "n", "v", "x" }, ";", ":", { desc = "Enter command mode" })
vim.keymap.set({ "n", "v", "x" }, ":", ";", { desc = "Repeat f/t motion" })

-- Remap ' pour jump exact (position exacte au lieu de début de ligne)
vim.keymap.set("n", "'", "`", { desc = "Jump to mark exact position" })

-- Insert date/time en mode insert
vim.cmd([[
  noremap! <c-r><c-d> <c-r>=strftime('%F')<cr>
  noremap! <c-r><c-t> <c-r>=strftime('%T')<cr>
]])

-- recentre l'ecran
vim.api.nvim_set_keymap('n', '<C-U>', '<C-U>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-D>', '<C-D>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-]>', '<C-]>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-o>', '<C-o>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-i>', '<C-i>zz', { noremap = true })

vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })





local ok_telescope, builtin = pcall(require, 'telescope.builtin')
if ok_telescope then
  vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
  vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
  vim.keymap.set('n', '<leader>fs', '<cmd>Telescope lsp_document_symbols<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>fS', '<cmd>Telescope lsp_workspace_symbols<CR>', { noremap = true, silent = true })
end


-- Native completion (Neovim 0.11+)
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('native_completion', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

vim.cmd [[set completeopt=menu,menuone,noselect]]

-- html filetype
vim.api.nvim_create_autocmd("FileType", {
  pattern = "html",
  callback = function()
    vim.opt_local.autoindent = false
    vim.opt_local.smartindent = false
    vim.opt_local.indentexpr = ""
  end
})

-- python filetype
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  command = "setlocal makeprg=python3\\ %"
})

-- Fix indentation pour TypeScript/React (ne pas utiliser Treesitter indent, il est buggé)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  callback = function()
    -- Utiliser smartindent au lieu de Treesitter indentexpr
    vim.opt_local.indentexpr = ""
    vim.opt_local.smartindent = true
    vim.opt_local.cindent = false
  end
})

local map = vim.keymap.set

if ok_telescope then
  map({ "n" }, "<leader>sg", builtin.git_files)
  map({ "n" }, "<leader>si", builtin.grep_string)
  map({ "n" }, "<leader>so", builtin.oldfiles)
  map({ "n" }, "<leader>sm", builtin.man_pages)
  map({ "n" }, "<leader>sr", builtin.lsp_references)
  map({ "n" }, "<leader>sd", builtin.diagnostics)
  map({ "n" }, "<leader>sT", builtin.lsp_type_definitions)
  map({ "n" }, "<leader>ss", builtin.current_buffer_fuzzy_find)
  map({ "n" }, "<leader>st", builtin.builtin)
  map({ "n" }, "<leader>sc", builtin.git_bcommits)
  map({ "n" }, "<leader>sk", builtin.keymaps)
  map({ "n" }, "<leader>se", "<cmd>Telescope env<cr>")
end

local ok_actions_preview, actions_preview = pcall(require, "actions-preview")
if ok_actions_preview then
  map({ "n" }, "<leader>sa", actions_preview.code_actions)
end

map({ "n" }, "<M-n>", "<cmd>resize +2<CR>")
map({ "n" }, "<M-e>", "<cmd>resize -2<CR>")
map({ "n" }, "<M-i>", "<cmd>vertical resize +5<CR>")
map({ "n" }, "<M-m>", "<cmd>vertical resize -5<CR>")
map({ "n" }, "<leader>c", "1z=")
map({ "n" }, "<C-q>", ":copen<CR>", { silent = true })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show diagnostic' })

-- Ou pour une version plus détaillée avec toutes les infos :
vim.keymap.set('n', '<leader>d', function()
  vim.diagnostic.open_float(nil, {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = 'rounded',
    source = 'always',
    prefix = ' ',
    scope = 'cursor',
  })
end, { desc = 'Show diagnostic float' })

vim.keymap.set('n', 'n', 'nzzzv')  -- Recherche toujours centrée
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y')  -- Copie vers clipboard système
vim.keymap.set("n", "<leader>a", ":edit #<CR>")  -- Retour au buffer précédent

-- Gestion des tabs
vim.keymap.set({ "n", "t" }, "<Leader>t", "<Cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set({ "n", "t" }, "<Leader>x", "<Cmd>tabclose<CR>", { desc = "Close tab" })

-- Navigation rapide entre tabs (1-8)
for i = 1, 8 do
  vim.keymap.set({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>", { desc = "Go to tab " .. i })
end
-- Configuration Telescope (utiliser les mappings par défaut)
local telescope = require('telescope')

telescope.setup({
  defaults = {
    -- Pas de mappings custom, on utilise les defaults de Telescope
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {}
    }
  }
})
telescope.load_extension('ui-select')

vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files, {
  noremap = true,
  silent = true,
  desc = "Find files"
})
