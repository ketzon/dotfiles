return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "<leader>l", mode = { "n", "x", "o" }, function()
        require("flash").jump()
        vim.cmd("normal! zz")
      end, desc = "Flash" },
    { "<leader>L", mode = { "n", "x", "o" }, function()
        require("flash").treesitter()
        vim.cmd("normal! zz")
      end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
