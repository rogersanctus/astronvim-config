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
