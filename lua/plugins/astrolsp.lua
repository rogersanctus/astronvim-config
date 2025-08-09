-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

local lspconfig = require "lspconfig"
local kls_path =
  vim.fn.expand "$HOME/sources/kotlin-language-server/server/build/install/server/bin/kotlin-language-server"

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      autoformat = true, -- enable or disable auto formatting on start
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
          "astro",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
        "volar",
      },
      filter = function(client)
        -- Disables html builtin formatting on save for heex files as it conflicts with elixir formatter
        if client.name == "html" then return vim.bo.filetype ~= "heex" end

        -- And enables all other formatters
        return true
      end,
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "gdscript",
      "kotlin_language_server",
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      clangd = { capabilities = { offsetEncoding = "utf-8" } },
      emmet_language_server = {
        filetypes = { "css", "html", "javascriptreact", "typescriptreact", "eelixir", "heex" },
      },
      haxe_language_server = {
        root_dir = lspconfig.util.root_pattern "*.hxml",
        filetypes = { "haxe" },
      },
      groovyls = {},
      html = { filetypes = { "html", "javascriptreact", "typescriptreact", "eelixir", "heex" } },
      phpactor = {
        filetypes = { "phpactor", "blade-actor" },
      },
      kotlin_language_server = {
        cmd = { kls_path },
      },
      lua_ls = {
        settings = {
          Lua = {
            format = {
              enable = false,
            },
            runtime = {
              version = "Lua 5.4",
            },
            hint = { enable = true },
          },
        },
      },
      tailwindcss = {
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
        filetypes = { "html", "javascriptreact", "typescriptreact", "eelixir", "heex", "astro", "vue", "scss", "css" },
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
      },
    },
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
      jdtls = false,
      -- gdscript = function(_, opts) require("lspconfig").gdscript.setup(opts) end,

      phpactor = function(_, opts)
        local phpactor_cmd_path = vim.fn.expand "$MASON/bin/phpactor"

        opts = vim.tbl_deep_extend("force", opts, {
          cmd = { phpactor_cmd_path, "language-server", "-vvv" },
          filetypes = { "php", "blade" },
        })

        lspconfig.phpactor.setup(opts)
      end,

      -- Typescript Language Server via (https://github.com/yioneko/vtsls)
      -- vtsls = function(_, opts)
      --   local has_mason_registry, mason_registry = pcall(require, "mason-registry")
      --
      --   if not has_mason_registry then
      --     lspconfig.vtsls.setup(opts)
      --     return
      --   end
      --
      --   local vls = mason_registry.get_package "vue-language-server"
      --
      --   if not vls:is_installed() then
      --     lspconfig.vtsls.setup(opts)
      --     return
      --   end
      --
      --   local vls_path = vls:get_install_path()
      --     .. "/node_modules/@vue/language-server"
      --     .. "/node_modules/@vue/typescript-plugin"
      --
      --   opts = vim.tbl_deep_extend("force", opts, {
      --     -- init_options = {
      --     --   plugins = {
      --     --     {
      --     --       name = "@vue/typescript-plugin",
      --     --       location = vls_path,
      --     --       languages = { "typescript", "javascript", "vue" },
      --     --     },
      --     --   },
      --     -- },
      --     settings = {
      --       vtsls = {
      --         tsserver = {
      --           globalPlugins = {
      --             {
      --               name = "@vue/typescript-plugin",
      --               location = vls_path,
      --               languages = { "typescript", "javascript", "vue" },
      --             },
      --           },
      --         },
      --       },
      --     },
      --     -- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      --   })
      --
      --   lspconfig.vtsls.setup(opts)
      -- end,

      volar = function(_, opts)
        local original_on_attach = opts.on_attach

        opts = vim.tbl_deep_extend("force", opts, {
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
          on_attach = function(client, bufn)
            client.handlers["tsserver/request"] = function(_, result, context)
              local clients = vim.lsp.get_clients { bufnr = context.bufnr, name = "vtsls" }
              if #clients == 0 then
                vim.notify(
                  "Could not found `vtsls` lsp client, vue_lsp would not work without it.",
                  vim.log.levels.ERROR
                )
                return
              end
              local ts_client = clients[1]

              local param = unpack(result)
              local id, command, payload = unpack(param)
              ts_client:exec_cmd({
                title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                command = "typescript.tsserverRequest",
                arguments = {
                  command,
                  payload,
                },
              }, { bufnr = context.bufnr }, function(_, cmd_handler_result)
                -- May be result is nil, so check it before trying to get its body
                local response = cmd_handler_result and cmd_handler_result.body
                local response_data = { { id, response } }
                client:notify("tsserver/response", response_data)
              end)
            end

            original_on_attach(client, bufn)

            -- Disable formatting through 'Vue Language Server'
            client.server_capabilities.documentFormattingProvider = false
          end,
        })

        lspconfig.volar.setup(opts)
      end,

      -- cssls
      cssls = function(_, opts)
        lspconfig.cssls.setup(vim.tbl_deep_extend("force", opts, {
          settings = {
            css = {
              lint = {
                unknownAtRules = "ignore",
              },
            },
            scss = {
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        }))
      end,
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_document_highlight = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/documentHighlight",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "CursorHold", "CursorHoldI" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Document Highlighting",
          callback = function() vim.lsp.buf.document_highlight() end,
        },
        {
          event = { "CursorMoved", "CursorMovedI", "BufLeave" },
          desc = "Document Highlighting Clear",
          callback = function() vim.lsp.buf.clear_references() end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        gl = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        -- gD = {
        --   function() vim.lsp.buf.declaration() end,
        --   desc = "Declaration of current symbol",
        --   cond = "textDocument/declaration",
        -- },
        -- ["<Leader>uY"] = {
        --   function() require("astrolsp.toggles").buffer_semantic_tokens() end,
        --   desc = "Toggle LSP semantic highlight (buffer)",
        --   cond = function(client) return client.server_capabilities.semanticTokensProvider and vim.lsp.semantic_tokens end,
        -- },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
      if client.server_capabilities.inlayHintProvider then
        local inlayhints_avail, inlayhints = pcall(require, "lsp-inlayhints")
        if inlayhints_avail then
          inlayhints.on_attach(client, bufnr)
          vim.keymap.set("n", "<leader>uH", function() inlayhints.toggle() end, { desc = "Toggle inlay hints" })
        end
      end

      -- if client.server_capabilities.declarationProvider then
      --   vim.keymap.set("n", "gd", function() vim.lsp.buf.declaration() end, { desc = "Go to declaration" })
      -- end

      if client.server_capabilities.definitionProvider then
        vim.keymap.set("n", "gD", function() vim.lsp.buf.definition() end, { desc = "Go to definition" })
      end
    end,
  },
}
