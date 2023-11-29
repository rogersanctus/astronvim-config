return {
  colorscheme = "nightfox",

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

    if jit.os == "Windows" then
      vim.cmd [[
        let &shell = executable("pwsh") ? 'pwsh' : 'powershell'
		    let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';'
	      let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
        let &shellpipe  = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
		    set shellquote= shellxquote=
      ]]
    end

    vim.keymap.set("i", "<M-S>", function() return vim.fn["codeium#Complete"]() end, { expr = true })
    vim.keymap.set(
      "n",
      "gd",
      "<cmd>normal! gd<CR>",
      { noremap = true, silent = true, desc = "Go to local declaration" }
    )

    if vim.fn.executable "rg" == 1 then
      vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
      vim.opt.grepformat = "%f:%l:%c:%m"
    end
  end,
}
