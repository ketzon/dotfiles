return {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('telescope').setup({
          defaults = {
            mappings = {
              i = {
                ['<C-p>'] = require('telescope.actions.layout').toggle_preview,
              },
              n = {
                ['<C-p>'] = require('telescope.actions.layout').toggle_preview,
              },
            },
          },
        })
      end,
}
