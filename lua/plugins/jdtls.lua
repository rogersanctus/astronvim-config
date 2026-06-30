return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      -- 0. Garante que temos uma tabela válida para não quebrar referências
      opts = opts or {}

      -- Helper síncrono para chamadas shell
      local function run_shell(cmd)
        local handle = io.popen(cmd)

        if not handle then
          return nil
        end

        local result = handle:read("*a")

        handle:close()

        return result
      end

      -- 1. Captura as versões do 'mise ls java'
      local ls_output = run_shell("mise ls java 2>/dev/null") or ""
      local installed_javas = {}
      local lts_versions = { [8] = true, [11] = true, [17] = true, [21] = true, [25] = true }

      for line in string.gmatch(ls_output, "[^\r\n]+") do
        -- Regex tolerante tanto ao output puro quanto ao formato tabular do mise
        local version_str = line:match("%s+java%s+(%S+)") or line:match("^java%s+(%S+)") or line:match("^(%S+)")

        if version_str then
          -- Limpa a variante isolando o bloco numérico (ex: "openjdk-21.0.2" -> "21.0.2")
          local ver_num = version_str:match("-(%d+%.?%d*.*)$") or version_str:match("^(%d+%.?%d*.*)$")

          if ver_num then
            local major = tonumber(ver_num:match("^(%d+)"))

            if major then
              table.insert(installed_javas, {
                full_string = "java@" .. version_str,
                version = ver_num,
                major = major,
                is_lts = lts_versions[major] or false,
              })
            end
          end
        end
      end

      if #installed_javas == 0 then
        return opts
      end

      -- 2. Ordenação semântica crescente por versão
      table.sort(installed_javas, function(a, b)
        if a.major ~= b.major then
          return a.major < b.major
        end

        local a_parts, b_parts = {}, {}

        for p in string.gmatch(a.version, "%d+") do
          table.insert(a_parts, tonumber(p))
        end

        for p in string.gmatch(b.version, "%d+") do
          table.insert(b_parts, tonumber(p))
        end

        for i = 1, math.max(#a_parts, #b_parts) do
          local va = a_parts[i] or 0
          local vb = b_parts[i] or 0

          if va ~= vb then
            return va < vb
          end
        end

        return false
      end)

      -- 3. Mapeia os runtimes usando 'mise where'
      local runtimes = {}

      for _, java in ipairs(installed_javas) do
        local path = run_shell("mise where " .. java.full_string .. " 2>/dev/null")

        if path then
          path = path:gsub("%s+$", "") -- Trim final

          if path ~= "" then
            table.insert(runtimes, {
              name = "JavaSE-" .. java.major,
              path = path,
              default = (java.major == 17),
            })
          end
        end
      end

      -- Injeta os runtimes descobertos de forma profunda na árvore de configurações
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          configuration = {
            runtimes = runtimes,
          },
        },
      })

      -- 4. Encontra a maior versão LTS disponível compatível com o JDTLS moderno (>= 21)
      local latest_lts = nil

      for i = #installed_javas, 1, -1 do
        if installed_javas[i].is_lts and installed_javas[i].major >= 21 then
          latest_lts = installed_javas[i]
          break
        end
      end

      -- Fallback caso não encontre explicitamente a flag LTS, pega a mais recente >= 21
      if not latest_lts then
        for i = #installed_javas, 1, -1 do
          if installed_javas[i].major >= 21 then
            latest_lts = installed_javas[i]
            break
          end
        end
      end

      -- 5. Aplica o wrapper do 'mise exec' preservando a estrutura base do LazyVim
      if latest_lts and opts.cmd then
        opts.cmd = vim.list_extend({ "mise", "exec", latest_lts.full_string, "--" }, opts.cmd)
      end

      return opts
    end,
  },
}
