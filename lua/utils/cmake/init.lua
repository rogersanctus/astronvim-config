local cmake_kits = require "utils.cmake.kits"

local ctx = {
  cwd = vim.fn.getcwd(),
  kit = nil,
}

function ctx.select_kit(cmake_args, configure_default_args)
  local kits = cmake_kits.get(ctx.cwd)

  if kits then
    for idx, kit in ipairs(kits) do
      if kit == ctx.kit then
        table.insert(kits, 1, table.remove(kits, idx))
        break
      end
    end

    vim.ui.select(kits, { prompt = "Select a CMake Kit:" }, function(kit_name)
      if not kit_name then return end
      if ctx.kit ~= kit_name then ctx.kit = kit_name end

      local kit = cmake_kits.build_env_and_args(kit_name, false, ctx.cwd)

      if kit then cmake_args.configure = vim.list_extend(configure_default_args, kit.args) end
    end)
  else
    vim.notify("No CMake Kit config file found.", vim.log.levels.ERROR)
  end
end

return ctx
