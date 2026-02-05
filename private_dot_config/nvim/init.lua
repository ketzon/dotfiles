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
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
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

-- recentre l'ecran
vim.api.nvim_set_keymap('n', '<C-U>', '<C-U>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-D>', '<C-D>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-]>', '<C-]>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-o>', '<C-o>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-i>', '<C-i>zz', { noremap = true })

vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })

local ok_mark, mark = pcall(require, 'harpoon.mark')
local ok_ui, ui = pcall(require, 'harpoon.ui')
if ok_mark and ok_ui then
  vim.keymap.set('n', '<leader>m', mark.add_file)
  vim.keymap.set('n', '<leader>h', ui.toggle_quick_menu)
  vim.keymap.set('n', '<leader>1', function() ui.nav_file(1) end)
  vim.keymap.set('n', '<leader>2', function() ui.nav_file(2) end)
  vim.keymap.set('n', '<leader>3', function() ui.nav_file(3) end)
  vim.keymap.set('n', '<leader>4', function() ui.nav_file(4) end)
end

vim.g.loaded_gutentags = 1
vim.g.gutentags_enabled = 0
vim.g.loaded_vim_tags = 1
vim.g.loaded_autotag = 1
vim.opt.tags = { vim.fn.stdpath("cache") .. "/tags" }

local ok_telescope, builtin = pcall(require, 'telescope.builtin')
if ok_telescope then
  vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
  vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
  vim.keymap.set('n', '<leader>fs', '<cmd>Telescope lsp_document_symbols<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>fS', '<cmd>Telescope lsp_workspace_symbols<CR>', { noremap = true, silent = true })
end


vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

vim.cmd [[set completeopt+=menuone,noselect,popup]]

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
vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files, {
  noremap = true,
  silent = true,
})
local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-p>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.move_selection_next,
      },
      n = {
        ["<C-p>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.move_selection_next,
      },
    },
  },
})
