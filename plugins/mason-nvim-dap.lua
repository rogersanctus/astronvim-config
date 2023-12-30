return {
  "jay-babu/mason-nvim-dap.nvim",
  opts = {
    ensure_installed = { "coreclr" },
    automatic_installation = true,
  },
  config = function(_, opts)
    local mason_dap = require "mason-nvim-dap"
    local functional = require "mason-core.functional"

    opts = vim.tbl_deep_extend("force", opts, {
      handlers = {
        -- Setup C# DAP configuration handlers
        -- mason-nvim-dap uses handlers to setup DAP
        coreclr = function(config)
          functional.each(
            function(configuration) configuration.env = { ASPNETCORE_ENVIRONMENT = "Development" } end,
            config.configurations
          )

          mason_dap.default_setup(config)
        end,
      },
    })

    mason_dap.setup(opts)
  end,
}
