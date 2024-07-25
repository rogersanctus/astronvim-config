-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

    if opts.ensure_installed ~= "all" then return end

    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "c_sharp",
      "lua",
      "vim",
      "haxe",
      -- add more arguments for adding more treesitter parsers
    })

    parser_config.haxe = {
      install_info = {
        url = "https://github.com/vantreeseba/tree-sitter-haxe",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "haxe",
    }
  end,
}
