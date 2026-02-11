return {
  'windwp/nvim-autopairs',
  event = "InsertEnter",  -- Charge seulement en mode insert
  config = function()
    local npairs = require('nvim-autopairs')
    
    npairs.setup({
      -- Intégration Treesitter pour contexte intelligent
      check_ts = true,
      ts_config = {
        lua = { 'string' },  -- Ne ferme pas dans strings Lua
        javascript = { 'template_string' },  -- Ne ferme pas dans template literals ``
        typescript = { 'template_string' },
        javascriptreact = { 'template_string', 'string' },
        typescriptreact = { 'template_string', 'string' },
      },
      
      -- Désactiver dans certains filetypes
      disable_filetype = { "TelescopePrompt", "vim" },
      
      -- Fast wrap avec Alt+e
      fast_wrap = {
        map = '<M-e>',  -- Alt+e pour activer fast wrap
        chars = { '{', '[', '(', '"', "'" },  -- Caractères déclencheurs
        pattern = [=[[%'%"%>%]%)%}%,]]=],  -- Pattern pour détecter fin
        end_key = '$',  -- $ pour aller jusqu'en fin de ligne
        keys = 'qwertyuiopzxcvbnmasdfghjkl',  -- Lettres de jump
        check_comma = true,
        highlight = 'Search',  -- Highlight des lettres (même couleur que recherche)
        highlight_grey = 'Comment'
      },
      
      -- Règles personnalisées
      enable_check_bracket_line = true,  -- Ne ferme pas si bracket déjà présent sur la ligne
      ignored_next_char = "[%w%.]",  -- Ignore si lettre ou . suit (évite `(foo)bar` → `(foo()bar`)
    })
    
    -- Règles custom pour JSX/TSX
    local Rule = require('nvim-autopairs.rule')
    local cond = require('nvim-autopairs.conds')
    
    -- Auto-close JSX tags <>
    npairs.add_rules({
      Rule("<", ">", { "javascriptreact", "typescriptreact" })
        :with_pair(cond.before_regex("%a+", 1))  -- Seulement si lettre avant (tag JSX)
        :with_move(function(opts) return opts.char == ">" end)
    })
  end,
}
