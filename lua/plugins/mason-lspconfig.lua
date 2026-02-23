local lemminx_path =
  vim.fn.expand "$HOME/sources/lemminx/org.eclipse.lemminx/target/lemminx-linux-aarch_64-0.31.1-SNAPSHOT"

-- use mason-lspconfig to configure LSP installations
return {
  "williamboman/mason-lspconfig.nvim",
  opts = function(_, opts)
    local arch = vim.uv.os_uname().machine

    local exclude_tbl = {
      "vtsls",
    }

    local ensure_installed = {
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
      "csharp_ls",
    }

    if arch == "aarch64" then
      table.insert(exclude_tbl, "lemminx")
      table.insert(exclude_tbl, "clangd")

      -- Lsp Config
      local lspconfig = require "lspconfig"

      lspconfig.lemminx.setup {
        cmd = { lemminx_path },
      }

      lspconfig.clangd.setup {
        cmd = { "clangd" },
      }
    else
      table.insert(ensure_installed, "clangd")
    end

    return vim.tbl_deep_extend("force", opts, {
      automatic_installation = {
        exclude = exclude_tbl,
      },
      ensure_installed = ensure_installed,
    })
  end,
}
