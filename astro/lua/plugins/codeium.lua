return {
  {
    "Exafunction/windsurf.nvim",
    event = "BufEnter",
    config = function(_, _opts)
      require("codeium").setup {
        enable_chat = false,
        enable_cmp_source = true,

        virtual_text = {
          enabled = true,
          manual = false,
          filetypes = {},
          default_filetype_enabled = true,
          idle_delay = 75,
          virtual_text_priority = 65535,
          map_keys = true,
          accept_fallback = nil,
          key_bindings = {
            -- Accept the current completion.
            accept = "<C-g>",
            -- Accept the next word.
            accept_word = false,
            -- Accept the next line.
            accept_line = false,
            -- Clear the virtual text.
            clear = "<C-x>",
            -- Cycle to the next completion.
            next = "<M-]>",
            -- Cycle to the previous completion.
            prev = "<M-[>",
          },
        },
      }
    end,
    dependencies = {
      {
        "AstroNvim/astroui",
        ---@type AstroUIOpts
        opts = {
          icons = {
            Codeium = "",
          },
        },
      },
      {
        "AstroNvim/astrocore",
        ---@param opts AstroCoreOpts
        opts = function(_, opts)
          local virtual_text = require "codeium.virtual_text"

          return require("astrocore").extend_tbl(opts, {
            mappings = {
              n = {
                ["<Leader>;"] = {
                  desc = require("astroui").get_icon("Codeium", 1, true) .. "Codeium",
                },
                ["<Leader>;o"] = {
                  desc = "Open Chat",
                  function() vim.cmd "Codeium Chat" end,
                },
              },
              i = {
                desc = "Codeium",

                ["<C-x>"] = {
                  desc = "Clear suggestions",
                  function() virtual_text.clear() end,
                },
                ["<M-\\>"] = {
                  desc = "Manually trigger completion",
                  function() return virtual_text.complete() end,
                  expr = true,
                  silent = true,
                },
              },
            },
          })
        end,
      },
    },
    specs = {
      {
        "hrsh7th/nvim-cmp",
        optional = true,
        opts = function(_, opts)
          -- Inject codeium into cmp sources, with high priority
          table.insert(opts.sources, 1, {
            name = "codeium",
            group_index = 1,
            priority = 10000,
          })
        end,
      },
      {
        "onsails/lspkind.nvim",
        optional = true,
        -- Adds icon for codeium using lspkind
        opts = function(_, opts)
          if not opts.symbol_map then opts.symbol_map = {} end
          opts.symbol_map.Codeium = require("astroui").get_icon("Codeium", 1, true)
        end,
      },
      {
        "echasnovski/mini.icons",
        optional = true,
        -- Adds icon for codeium using mini.icons
        opts = function(_, opts)
          if not opts.lsp then opts.lsp = {} end
          if not opts.symbol_map then opts.symbol_map = {} end
          opts.symbol_map.codeium = { glyph = require("astroui").get_icon("Codeium", 1, true), hl = "MiniIconsCyan" }
        end,
      },
    },
  },
}
