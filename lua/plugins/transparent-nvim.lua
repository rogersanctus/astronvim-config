return {
  "xiyaowong/transparent.nvim",
  lazy = false,
  opts = {},
  config = function()
    local transparent = require "transparent"

    transparent.setup {
      extra_groups = { -- table/string: additional groups that should be cleared
        -- In particular, when you set it to 'all', that means all available groups
        -- example of akinsho/nvim-bufferline.lua
        "BufferLineTabClose",
        "BufferlineBufferSelected",
        "BufferLineFill",
        "BufferLineBackground",
        "BufferLineSeparator",
        "BufferLineIndicatorSelected",
        "BufferTabPage",
        "BufferTabPages",

        "NormalFloat",
      },

      exclude_groups = {}, -- table: groups you don't want to clear
    }

    transparent.clear_prefix "NeoTree"
  end,
}
