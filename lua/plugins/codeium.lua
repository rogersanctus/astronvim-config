return {
  {
    event = "BufEnter",
    "Exafunction/codeium.vim",
    config = function()
      -- Disable default mappings
      vim.g.codeium_disable_bindings = 1

      -- Setup codeium to show completions manually

      -- Insert current suggestion
      vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true, silent = true })

      -- Clear current suggestion
      vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true, silent = true })

      -- Previous suggestion
      vim.keymap.set(
        "i",
        "<M-[>",
        function() return vim.fn["codeium#CycleCompletions"](-1) end,
        { expr = true, silent = true }
      )

      -- Next suggestion
      vim.keymap.set(
        "i",
        "<M-]>",
        function() return vim.fn["codeium#CycleCompletions"](1) end,
        { expr = true, silent = true }
      )

      -- Manually trigger completion
      vim.keymap.set("i", "<M-\\>", function() return vim.fn["codeium#Complete"]() end, { expr = true, silent = true })
    end,
  },
}
