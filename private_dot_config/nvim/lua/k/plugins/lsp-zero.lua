-- lua/k/plugins/lsp-zero.lua
return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },

  { 'williamboman/mason.nvim', version = false, lazy = false, config = true },

  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets' },
  },

  -- Autocomplétion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = { 'L3MON4D3/LuaSnip' },
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        formatting = lsp_zero.cmp_format({ details = true }),
        sources = { {name='nvim_lsp'}, {name='luasnip'}, {name='buffer'}, {name='path'} },
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        }),
        snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
      })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    cmd   = { 'LspInfo', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function()
      local lsp_zero = require('lsp-zero')

      -- keymaps par défaut
      lsp_zero.on_attach(function(_, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
      end)

      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- lua
      local lua_opts = lsp_zero.nvim_lua_ls()
      lua_opts.capabilities = capabilities
      lspconfig.lua_ls.setup(lua_opts)

      -- web
      lspconfig.html.setup({ capabilities = capabilities })
      lspconfig.cssls.setup({ capabilities = capabilities })
      lspconfig.emmet_ls.setup({ capabilities = capabilities })
      lspconfig.ts_ls.setup({ capabilities = capabilities })
      lspconfig.tailwindcss.setup({ capabilities = capabilities })

      -- PHP
      lspconfig.intelephense.setup({
        capabilities = capabilities,
        -- init_options = { licenceKey = "..." }, -- si tu as une licence pro
      })
    end,
  },
}
