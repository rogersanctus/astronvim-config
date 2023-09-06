-- create an augroup to easily manage autocommands
vim.api.nvim_create_augroup("lsp", { clear = true })
-- create a new autocmd on the "User" event
vim.api.nvim_create_autocmd("User", {
  desc = "Apply All Eslint Fixes on buffer save",
  -- triggered when vim.t.bufs is updated
  pattern = "AstroLspSetup",
  group = "lsp",
  callback = function()
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      --command = "EslintFixAll",
      callback = function()
        local clients = vim.lsp.get_active_clients()

        -- check if 'eslint' in active
        for _, client in ipairs(clients) do
          if client.name == "eslint" then
            vim.cmd "EslintFixAll"
            break
          end
        end
      end,
    })
  end,
})

-- Once, at VimEnter, check if Alpha dashboard "is loaded".
-- It will be already loaded when nvim is started without a directory as argument.
vim.api.nvim_create_autocmd({'VimEnter'}, {
  once = true,
  callback = function()
    local args = vim.fn.argv()

    if #args > 0 then
      local path = args[1]
      vim.g.alpha_dashboard_loaded = not vim.fn.isdirectory(path)
    end
  end
})

-- When receive a BufEnter, as BufAdd is not called for empty bufs created at start,
-- Start alpha dashboard.
vim.api.nvim_create_autocmd({'BufEnter'}, {
  desc = 'Load dashboard at start',
  callback = function(args)
    -- Continue only if Alpha dashboard is not loaded.
    if vim.g.alpha_dashboard_loaded == false then
      if args.buf ~= nil then
        local bufname = vim.fn.bufname(args.buf)

        -- Only if buffer has no name
        if vim.api.nvim_buf_is_loaded(args.buf) == true and bufname == '' then
          require("alpha").start(false)
          vim.cmd('bw! ' .. args.buf) -- wipeout completely the buffer

          vim.g.alpha_dashboard_loaded = true
        end
      end
    end
  end
})
