return {
  'stevearc/conform.nvim',
  keys = {
    {
      "<leader>p",
      function()
        require("conform").format({
          async = true,           -- Pas de freeze pendant le format
          timeout_ms = 3000,      -- Timeout de 3s (au cas où Prettier est lent)
          lsp_format = "never",   -- Prettier uniquement (pas de fallback LSP)
        })
      end,
      mode = { "n", "v" },
      desc = "Format with Prettier"
    },
  },
  opts = {
    -- Définit quel formatter utiliser pour chaque type de fichier
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      vue = { "prettier" },
    },
    
    -- PAS de format_on_save = format UNIQUEMENT sur <leader>p
  },
}
