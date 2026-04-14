local function make_slint_settings(config)
  -- config.root_dir é detectado automaticamente pelo lspconfig
  local root = config.root_dir

  if not root then
    return
  end

  local config_path = root .. "/.slint-lsp.json"

  -- Usando vim.uv para checagem de arquivo (API moderna 0.10+)
  local stat = vim.uv.fs_stat(config_path)

  if stat and stat.type == "file" then
    local f = io.open(config_path, "r")
    if f then
      local content = f:read("*a")
      f:close()

      local ok, json = pcall(vim.json.decode, content)

      if ok then
        -- Forçamos a atualização dos settings ANTES do initialize
        local settings = vim.tbl_deep_extend("force", config.settings or {}, { slint = json })
        -- config.settings = {}
        -- print(vim.inspect(config))
        return settings
      end
    end
  end

  return {}
end

---@type vim.lsp.Config
vim.lsp.config["slint_lsp"] = {
  root_markers = { ".git", ".slint-lsp.json" },
  on_init = function(client)
    print(vim.inspect(client))
    local settings = make_slint_settings(client.config)
    print(vim.inspect(settings))

    ---@diagnostic disable-next-line
    client.settings = settings -- For some reason, slint_lsp uses client.settings and not client.config.settings to initialize

    client.config.settings = settings
  end,
}

vim.lsp.config.lua_ls = {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
}

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      slint_lsp = {
        -- settings = {
        --   includePaths = {
        --     "jesico",
        --   },
        -- },
      },
    },
  },
}
