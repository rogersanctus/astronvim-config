return {
  opt = {
    -- set to true or false etc.
    lazyredraw = false,
    relativenumber = false, -- sets vim.opt.relativenumber
    number = true, -- sets vim.opt.number
    spell = false, -- sets vim.opt.spell
    signcolumn = "auto", -- sets vim.opt.signcolumn to auto
    wrap = false, -- sets vim.opt.wrap
    list = true,
    listchars = { tab = "→ ", extends = "⟩", precedes = "⟨", trail = "·", nbsp = "␣", eol = "↲" },
    swapfile = false,
    termguicolors = true,
    guicursor = "n-v-c:block,i-ci-ve:ver25-blinkwait500-blinkoff400-blinkon200,r-cr:hor20,o:hor50,a:Cursor/lCursor",
  },
  g = {
    autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    cmp_enabled = true, -- enable completion at start
    autopairs_enabled = true, -- enable autopairs at start
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    ui_notifications_enabled = true, -- disable notifications when toggling UI elements
    codelens_enabled = true, -- enable or disable automatic codelens refreshing for lsp that support it
    inlay_hints_enabled = true, -- enable or disable LSP inlay hints on startup (Neovim v0.10 only)
  },
}
