-- lua/k/plugins/lsp-zero.lua
return {
  -- lsp-zero (glue)
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- on gère cmp & lspconfig nous-mêmes
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },

  -- Mason (gestionnaire d'outils LSP/DAP/formatters)
  { 'williamboman/mason.nvim', lazy = false, config = true },

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
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
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<CR>']     = cmp.mapping.confirm({ select = false }),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>']    = cmp.mapping.scroll_docs(-4),
          ['<C-d>']    = cmp.mapping.scroll_docs(4),
          ['<C-f>']    = cmp_action.luasnip_jump_forward(),
          ['<C-b>']    = cmp_action.luasnip_jump_backward(),
        }),
        snippet = {
          expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },
      })
    end,
  },

  -- LSP (API mason-lspconfig v2)
  {
    'neovim/nvim-lspconfig',
    cmd   = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      { 'williamboman/mason.nvim'},
      { 'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      local lsp_zero = require('lsp-zero')

      -- keymaps par défaut quand un LSP s’attache
      lsp_zero.on_attach(function(_, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
      end)

      -- Mason
      require('mason').setup({})

      -- Serveurs à installer (mason-lspconfig v2)
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'html',
          'cssls',
          'emmet_ls',
          'ts_ls',      -- nouveau nom de tsserver
          'tailwindcss',
        },
      })

      -- Capacités pour nvim-cmp
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Handlers: config par défaut + override pour lua_ls
      require('mason-lspconfig').setup_handlers({
        function(server_name)
          require('lspconfig')[server_name].setup({
            capabilities = capabilities,
          })
        end,
        lua_ls = function()
          local lua_opts = lsp_zero.nvim_lua_ls()
          lua_opts.capabilities = capabilities
          require('lspconfig').lua_ls.setup(lua_opts)
        end,
      })
    end,
  },
}
