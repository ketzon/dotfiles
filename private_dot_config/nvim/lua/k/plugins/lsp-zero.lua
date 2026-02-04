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
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    },
  },

  { 'williamboman/mason.nvim', lazy = false, opts = {} },

  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets' },
  },

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = { 'L3MON4D3/LuaSnip', 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path' },
    config = function()
      local lsp_zero = require('lsp-zero')
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
          ['<CR>']      = cmp.mapping.confirm({ select = false }),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>']     = cmp.mapping.scroll_docs(-4),
          ['<C-d>']     = cmp.mapping.scroll_docs(4),
          ['<C-f>']     = cmp_action.luasnip_jump_forward(),
          ['<C-b>']     = cmp_action.luasnip_jump_backward(),
        }),
        snippet = {
          expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },
      })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'html',
          'cssls',
          'emmet_ls',
          'tailwindcss',
          'ts_ls',
          'intelephense',
        },
      })

      -- Keymaps LSP
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local opts = { buffer = event.buf }
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'x' }, '<F3>', vim.lsp.buf.format, opts)
          vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
        end,
      })

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

      -- lua
      vim.lsp.config.lua_ls = {
        cmd = { mason_bin .. "/lua-language-server" },
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME }
            },
            diagnostics = { globals = { 'vim' } },
            telemetry = { enable = false },
          },
        },
      }
      vim.lsp.enable('lua_ls')

      -- web
      vim.lsp.config.html = {
        cmd = { mason_bin .. "/vscode-html-language-server", "--stdio" },
        capabilities = capabilities
      }
      vim.lsp.enable('html')

      vim.lsp.config.cssls = {
        cmd = { mason_bin .. "/vscode-css-language-server", "--stdio" },
        capabilities = capabilities
      }
      vim.lsp.enable('cssls')

      vim.lsp.config.emmet_ls = {
        cmd = { mason_bin .. "/emmet-ls", "--stdio" },
        capabilities = capabilities
      }
      vim.lsp.enable('emmet_ls')

      vim.lsp.config.tailwindcss = {
        cmd = { mason_bin .. "/tailwindcss-language-server", "--stdio" },
        capabilities = capabilities
      }
      vim.lsp.enable('tailwindcss')

      -- typescript/javascript
      vim.lsp.config.ts_ls = {
        cmd = { mason_bin .. "/typescript-language-server", "--stdio" },
        capabilities = capabilities
      }
      vim.lsp.enable('ts_ls')

      -- php
      vim.lsp.config.intelephense = {
        cmd = { mason_bin .. "/intelephense", "--stdio" },
        capabilities = capabilities
      }
      vim.lsp.enable('intelephense')
    end,
  },
}
