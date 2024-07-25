-- use mason-lspconfig to configure LSP installations
return {
  "williamboman/mason-lspconfig.nvim",
  opts = {
    automatic_installation = {
      exclude = {
        "unocss",
      },
    },
    ensure_installed = {
      "clangd",
      "csharp_ls",
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
      -- "unocss",
      -- "kotlin_language_server",
      "tailwindcss",
      "emmet_language_server",
      "zls",
    },
  },
}
