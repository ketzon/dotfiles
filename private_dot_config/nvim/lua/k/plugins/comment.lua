return {
  'numToStr/Comment.nvim',
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  config = function()
    require('Comment').setup({
      -- Support Treesitter pour commentaires JSX/TSX contextuels
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      
      -- Keymaps (par défaut mais explicites pour référence)
      toggler = {
        line = 'gcc',  -- Toggle ligne
        block = 'gbc', -- Toggle bloc
      },
      opleader = {
        line = 'gc',   -- gc + motion
        block = 'gb',  -- gb + motion
      },
    })
  end,
}
