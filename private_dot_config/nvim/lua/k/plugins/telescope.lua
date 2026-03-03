return {
  'nvim-telescope/telescope.nvim', 
  tag = '0.1.8',
  dependencies = { 
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local telescope = require('telescope')
    
    telescope.setup({
      defaults = {
        preview = { treesitter = true },
        color_devicons = true,
        sorting_strategy = "ascending",
        borderchars = {
          "", -- top
          "", -- right
          "", -- bottom
          "", -- left
          "", -- top-left
          "", -- top-right
          "", -- bottom-right
          "", -- bottom-left
        },
        path_display = { "smart" },
        layout_config = {
          height = 100,
          width = 400,
          prompt_position = "top",
          preview_cutoff = 40,
        }
      }
    })
  end,
}
