-- use mason-lspconfig to configure LSP installations
return {
  "williamboman/mason-lspconfig.nvim",
  opts = {
    automatic_installation = {
      exclude = {
        "vtsls",
      },
    },
    ensure_installed = {
      "clangd",
      "cssls",
      "eslint",
      "html",
      "haxe_language_server",
      "marksman",
      "jdtls",
      "jsonls",
      "pyright",
      "sqlls",
      "lua_ls",
      "yamlls",
      "elixirls",
      "tailwindcss",
      "emmet_language_server",
      "zls",
    },
  },
}
