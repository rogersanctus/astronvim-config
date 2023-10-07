return function(client, bufnr)
  if client.server_capabilities.inlayHintProvider then
    local inlayhints_avail, inlayhints = pcall(require, "lsp-inlayhints")
    if inlayhints_avail then
      inlayhints.on_attach(client, bufnr)
      vim.keymap.set("n", "<leader>uH", function() inlayhints.toggle() end, { desc = "Toggle inlay hints" })
    end
  end

  if client.server_capabilities.definitionProvider then
    vim.keymap.set("n", "gD", function() vim.lsp.buf.definition() end, { desc = "Go to definition" })
  end
end
