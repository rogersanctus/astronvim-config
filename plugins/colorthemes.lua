return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    config = function()
      require('kanagawa').setup({
        compile = false,             -- enable compiling the colorscheme
        undercurl = true,            -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true},
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,         -- do not set background color
        dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
        terminalColors = true,       -- define vim.g.terminal_color_{0,17}
        colors = {                   -- add/modify theme and palette colors
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors) -- add/modify highlights
          return {}
        end,
        theme = "wave",              -- Load "wave" theme when 'background' option is not set
        background = {               -- map the value of 'background' option to a theme
          dark = "wave",           -- try "dragon" !
          light = "lotus"
        },
      })
    end
  },

  {
    "sainnhe/edge",
    lazy = false
  },

  {
    "d00h/nvim-rusticated"
  },

  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    config = function()
      require('nightfox').setup({
        options = {
          -- Compiled file's destination location
          compile_path = vim.fn.stdpath("cache") .. "/nightfox",
          compile_file_suffix = "_compiled", -- Compiled file suffix
          transparent = false,     -- Disable setting background
          terminal_colors = true,  -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
          dim_inactive = false,    -- Non focused panes set to alternative background
          module_default = true,   -- Default enable value for modules

          inverse = {             -- Inverse highlight for different types
            match_paren = true,
            visual = false,
            search = false,
          },
          modules = {             -- List of various plugins and additional options
            -- ...
            notify = {
              enabled = true,
              background = false
            }
          },
        },
        palettes = {},
        specs = {},
        groups = {},
      })
    end
  },

  {
    "yorik1984/newpaper.nvim",
    lazy = false,
    priority = 1000,
    config = true,
  }
  
}
