return {
  'JoosepAlviste/nvim-ts-context-commentstring',
  lazy = true,
  opts = {
    enable_autocmd = false, -- Géré par Comment.nvim
    languages = {
      typescript = { __default = '// %s', __multiline = '/* %s */' },
      typescriptreact = { __default = '{/* %s */}', __multiline = '{/* %s */}' },
      javascript = { __default = '// %s', __multiline = '/* %s */' },
      javascriptreact = { __default = '{/* %s */}', __multiline = '{/* %s */}' },
    },
  },
}
