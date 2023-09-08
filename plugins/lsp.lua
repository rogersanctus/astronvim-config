return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    init = function() table.insert(astronvim.lsp.skip_setup, 'tsserver') end,
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    opts = function()
      return {
        server = require('astronvim.utils.lsp').config('tsserver')
      }
    end,
  }
}
