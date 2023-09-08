local lsp_util = require('lspconfig.util')
local home_path = os.getenv("HOME")
local servers_path = home_path .. '/lsp-servers'
local server_path = servers_path .. '/unocss-language-server/bin/server.sh'

return {
  cmd = { server_path, '--stdio' },
  file_types = {
    "html",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  -- root_dir = function(fname)
  --   return lsp_util.root_pattern('unocss.config.ts')(fname)
  -- end
}
