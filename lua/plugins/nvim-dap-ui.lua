return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "folke/neodev.nvim",
  },
  opts = function(_, opts)
    return {
      expand_lines = true,
      layouts = {
        {
          elements = {
            {
              id = "repl",
              size = 0.1,
            },
            {
              id = "scopes",
              size = 0.5,
            },
            {
              id = "watches",
              size = 0.5,
            },
          },
          position = "left",
          size = 30,
        },
        {
          elements = {
            {
              id = "console",
              size = 1.0,
            },
          },
          position = "bottom",
          size = 10,
        },
      },
    }
  end,
}
