return {
  colorscheme = 'newpaper',

  -- diagnostics = {
  --   virtual_text = false,
  --   underline = true,
  -- },

  polish = function()
    require "user.autocmds"

    vim.g.clipboard = {
      name = "WslClipboard",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      },
      cache_enabled = 0,
    }

    vim.keymap.set("i", "<M-S>", function() return vim.fn["codeium#Complete"]() end, { expr = true })
    vim.keymap.set("n", "<C-m>", "<C-v>")

    if vim.fn.executable "rg" == 1 then
      vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
      vim.opt.grepformat = "%f:%l:%c:%m"
    end
  end,
}
