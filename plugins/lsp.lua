return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    init = function() table.insert(astronvim.lsp.skip_setup, "tsserver") end,
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = function() return {} end,
    config = function(_, opts)
      require("typescript-tools").setup {
        on_attach = function(client, bufnr)
          require("astronvim.utils.lsp").on_attach(client, bufnr)
          vim.api.nvim_buf_del_keymap(bufnr, "n", "gd")
        end,
      }
    end,
  },
}
