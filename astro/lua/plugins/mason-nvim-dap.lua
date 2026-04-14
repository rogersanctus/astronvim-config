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

        function(config) mason_dap.default_setup(config) end,

        coreclr = function(config)
          functional.each(function(configuration)
            configuration.env = { ASPNETCORE_ENVIRONMENT = "Development" }
            configuration.cwd = function() return vim.fn.input("Workspace folder", vim.fn.getcwd() .. "/", "file") end
          end, config.configurations)

          config.adapters = {
            type = "executable",
            command = vim.fn.exepath "netcoredbg",
            args = { "--interpreter=vscode" },
          }

          -- config.configurations = {
          --   {
          --     justMyCode = false,
          --     stopAtEntry = false,
          --     type = "coreclr",
          --     name = "launch - netcoredbg",
          --     request = "launch",
          --     --[[ ,  ]]
          --     program = function() return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/net8.0/", "file") end,
          --     cwd = function() return vim.fn.input("Workspace folder", vim.fn.getcwd() .. "/", "file") end,
          --   },
          -- }

          mason_dap.default_setup(config)
        end,
      },
    })

    mason_dap.setup(opts)
  end,
}
