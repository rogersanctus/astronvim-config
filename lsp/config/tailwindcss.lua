local lspconfig = require "lspconfig"

return {
  --      capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern(
    "tailwind.config.js",
    "tailwind.config.ts",
    "postcss.config.js",
    "postcss.config.ts",
    "package.json",
    "node_modules",
    ".git",
    "mix.exs"
  ),
  filetypes = { "html", "javascriptreact", "typescriptreact", "eelixir", "heex", "astro" },
  init_options = {
    userLanguages = {
      heex = "html-eex",
    },
  },
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          'class[:]\\s*"([^"]*)"',
        },
      },
    },
  },
}
