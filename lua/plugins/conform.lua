return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require "conform"

    conform.formatters.groovyfmt = function(bufn)
      return {
        stdin = true,
        command = "npm-groovy-lint",
        args = { "--format", "-" },
      }
    end

    conform.setup {
      formatters_by_ft = {
        lua = { "stylua" },
        groovy = { "groovyfmt" },
      },
      format_on_save = {
        timeout_ms = 800,
        lsp_fallback = true,
        async = false,
      },
    }
  end,
}
