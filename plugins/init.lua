return {
  -- You can disable plugins here
  -- {"user/plugin.nvim", enabled = false },
  -- You can add new plugins here
  { "lvimuser/lsp-inlayhints.nvim", config = true },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    config = function() require("lsp_signature").setup {} end,
  },
  {
    "goolord/alpha-nvim",
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    enabled = false,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    enabled = false,
  },
}
