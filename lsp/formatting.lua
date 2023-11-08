return {
  format_on_save = {
    enabled = true,

    ignore_filetypes = {
      "astro",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
  },
  filter = function(client)
    -- Disables html builtin formatting on save for heex files as it conflicts with elixir formatter
    if client.name == "html" then return vim.bo.filetype ~= "heex" end
    -- And enables elixir formatter
    if client.name == "elixirls" then return true end
  end,
}
