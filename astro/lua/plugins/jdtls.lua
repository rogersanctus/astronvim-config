--[[
  Configures nvim-jdtls for Java development with jdtls as language-server,
  microsoft/java-debug-adapter for DAP and vs-code java-test for testing support on DAP.
]]

-- Uses mise to get JDKs grouped by major version, getting the greatest version of each group.
local function get_jdks()
  local jdks = vim.fn.system 'mise ls java | grep -oP "(?<=java).*" | sed -E "s/\\s*(\\S)\\s+.*/\\1/g"'
  local all_jdks = {}
  local jdk_all_versions = {}
  local jdk_versions = {}

  for jdk in jdks:gmatch "([^\n]+)" do
    jdk = jdk:gsub("^%s*", "")
    local version_str = jdk:gsub("^.+%-", "")
    local major_str = version_str:match "^%d+"

    if major_str ~= nil then
      local entries = jdk_all_versions[major_str] or {}
      local entry = {}
      local version_sum = 0
      local version_weight = 1

      for version_part in version_str:gmatch "%d+" do
        local version_part_num = tonumber(version_part)

        if version_part_num ~= nil then
          version_sum = version_sum + version_part_num * version_weight
          version_weight = version_weight * 0.1
        end
      end

      entry.major = major_str
      entry.full_version = jdk
      entry.version_sum = version_sum

      table.insert(entries, entry)
      jdk_all_versions[major_str] = entries
    end

    table.insert(all_jdks, jdk)
  end

  -- Makes the list of jdk versions
  for _, v in pairs(jdk_all_versions) do
    local greatest = v[1]

    -- Find the greatest version of each group
    for _, entry in pairs(v) do
      if entry.version_sum > greatest.version_sum then greatest = entry end
    end

    table.insert(jdk_versions, {
      name = "JavaSE-" .. greatest.major,
      versionMajor = greatest.major,
      versionName = greatest.full_version,
    })
  end

  return jdk_versions
end

return {
  "mfussenegger/nvim-jdtls",
  opts = function(_, opts)
    local runtimes = {}
    local java_cmd = "java"

    if vim.fn.has "unix" then
      local jdks = get_jdks()

      -- Builds the runtimes list for jdtls
      for k, v in pairs(jdks) do
        -- Uses https://mise.jdx.dev to find the path to the JDKs. They must have been installed with mise.
        local path = vim.fn.system("mise where java@" .. v.versionName)

        local runtime = {
          name = v.name,
          path = path:gsub("%s+$", "") .. "/",
        }

        -- Take the JDK path as the JdtLs runtime jdk - minimum version is Java 17
        if v.versionMajor == "17" then java_cmd = runtime.path .. "bin/java" end

        table.insert(runtimes, runtime)
      end
    end

    local cmd = opts.cmd
    table.remove(cmd, 1)
    table.insert(cmd, 1, java_cmd)

    local config = {
      cmd = cmd,
      settings = {
        java = {
          configuration = {
            runtimes = runtimes,
          },
        },
      },
    }

    return vim.tbl_deep_extend("force", opts, config)
  end,
}
-- return {
--   "mfussenegger/nvim-jdtls",
--   ft = { "java" },
--   dependencies = { "williamboman/mason-lspconfig.nvim" },
--   opts = function(_, opts)
--     -- use this function notation to build some variables
--     local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", ".project" }
--     local root_dir = require("jdtls.setup").find_root(root_markers)
--     -- calculate workspace dir
--     local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
--     local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
--     os.execute("mkdir " .. workspace_dir)
--
--     -- get the current OS
--     local os
--     if vim.fn.has "mac" == 1 then
--       os = "mac"
--     elseif vim.fn.has "unix" == 1 then
--       os = "linux"
--     elseif vim.fn.has "win32" == 1 then
--       os = "win"
--     end
--
--     -- ensure that OS is valid
--     if not os or os == "" then require("astrocore").notify("jdtls: Could not detect valid OS", vim.log.levels.ERROR) end
--
--     local bundles = {
--       vim.fn.glob("$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar", true),
--     }
--
--     vim.list_extend(bundles, vim.split(vim.fn.glob "$MASON/share/java-test/*.jar", "\n"))
--
--     local defaults = {
--       cmd = {
--         "java",
--         "-Declipse.application=org.eclipse.jdt.ls.core.id1",
--         "-Dosgi.bundles.defaultStartLevel=4",
--         "-Declipse.product=org.eclipse.jdt.ls.core.product",
--         "-Dlog.protocol=true",
--         "-Dlog.level=ALL",
--         "-javaagent:" .. vim.fn.expand "$MASON/share/jdtls/lombok.jar",
--         "-Xms1g",
--         "--add-modules=ALL-SYSTEM",
--         "--add-opens",
--         "java.base/java.util=ALL-UNNAMED",
--         "--add-opens",
--         "java.base/java.lang=ALL-UNNAMED",
--         "-jar",
--         vim.fn.expand "$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
--         "-configuration",
--         vim.fn.expand "$MASON/share/jdtls/config",
--         "-data",
--         workspace_dir,
--       },
--       root_dir = root_dir,
--       settings = {
--         java = {
--           eclipse = {
--             downloadSources = true,
--           },
--           configuration = {
--             updateBuildConfiguration = "interactive",
--           },
--           maven = {
--             downloadSources = true,
--           },
--
--           implementationsCodeLens = {
--             enabled = true,
--           },
--           referencesCodeLens = {
--             enabled = true,
--           },
--         },
--         signatureHelp = {
--
--           enabled = true,
--         },
--         completion = {
--           favoriteStaticMembers = {
--             "org.hamcrest.MatcherAssert.assertThat",
--             "org.hamcrest.Matchers.*",
--             "org.hamcrest.CoreMatchers.*",
--             "org.junit.jupiter.api.Assertions.*",
--             "java.util.Objects.requireNonNull",
--             "java.util.Objects.requireNonNullElse",
--             "org.mockito.Mockito.*",
--           },
--         },
--         sources = {
--           organizeImports = {
--             starThreshold = 9999,
--             staticStarThreshold = 9999,
--           },
--         },
--       },
--       init_options = {
--         bundles = bundles,
--       },
--       handlers = {
--         ["$/progress"] = function()
--           -- disable progress updates.
--         end,
--         ["jdtls"] = false,
--       },
--       filetypes = { "java" },
--       on_attach = function(client, bufnr)
--         require("jdtls").setup_dap { hotcodereplace = "auto" }
--         require("astrolsp").on_attach(client, bufnr)
--       end,
--     }
--
--     -- TODO: add overwrite for on_attach
--
--     -- ensure that table is valid
--     if not opts then opts = {} end
--
--     -- extend the current table with the defaults keeping options in the user opts
--     -- this allows users to pass opts through an opts table in community.lua
--     opts = vim.tbl_deep_extend("keep", opts, defaults)
--
--     -- send opts to config
--     return opts
--   end,
--   config = function(_, opts)
--     -- setup autocmd on filetype detect java
--     vim.api.nvim_create_autocmd("Filetype", {
--       pattern = "java", -- autocmd to start jdtls
--       callback = function()
--         if opts.root_dir and opts.root_dir ~= "" then
--           require("jdtls").start_or_attach(opts)
--           -- require("jdtls.dap").setup_dap_main_class_configs()
--         else
--           require("astrocore").notify("jdtls: root_dir not found. Please specify a root marker", vim.log.levels.ERROR)
--         end
--       end,
--     })
--     -- create autocmd to load main class configs on LspAttach.
--     -- This ensures that the LSP is fully attached.
--     -- See https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
--     vim.api.nvim_create_autocmd("LspAttach", {
--       pattern = "*.java",
--       callback = function(args)
--         local buffer = args.buf
--         local client = vim.lsp.get_client_by_id(args.data.client_id)
--         local whichkey = require "which-key"
--
--         -- ensure that only the jdtls client is activated
--         if client.name == "jdtls" then
--           -- setup dap
--           require("jdtls.dap").setup_dap_main_class_configs()
--
--           -- Adds some keybindings for debugging tests
--           whichkey.register({
--             d = {
--               T = {
--                 function() require("jdtls.dap").test_class() end,
--                 "Test current Class",
--                 noremap = true,
--                 buffer = buffer,
--               },
--               t = {
--                 function() require("jdtls.dap").test_nearest_method() end,
--                 "Test nearest Method to cursor",
--                 noremap = true,
--                 buffer = buffer,
--               },
--             },
--           }, { prefix = "<leader>" })
--         end
--       end,
--     })
--   end,
-- }
