return {
  "Shatur/neovim-tasks",
  main = "tasks",
  lazy = false,
  config = function(_, opts)
    local tasks_config = require "tasks.config"
    local tasks_cmake = require "tasks.module.cmake"
    local cmake_util = require "utils.cmake"
    local cmake_kits = require "utils.cmake.kits"
    local nvim_tasks = require "tasks"
    local which_key = require "which-key"

    local cmake_args = vim.tbl_get(tasks_config, "defaults", "default_params", "cmake", "args") or {}
    local cmake_args_configure_default = cmake_args.configure

    tasks_cmake.params = vim.tbl_deep_extend("force", tasks_cmake.params, {
      kit = function() return cmake_kits.get(vim.fn.getcwd()) end,
    })

    nvim_tasks.setup {
      default_params = {
        cmake = {
          args = cmake_args,
          kit = nil,
        },
      },
    }

    which_key.add {
      { "<M-t>", group = "Tasks" },
      { "<M-t>c", group = "CMake Tasks" },
      { "<M-t>cb", "<cmd>Task start cmake build<cr>", desc = "CMake Build", remap = false },
      { "<M-t>cc", "<cmd>Task start cmake clean<cr>", desc = "CMake Clean", remap = false },
      { "<M-t>cd", "<cmd>Task start cmake debug<cr>", desc = "CMake Debug", remap = false },
      { "<M-t>cg", "<cmd>Task start cmake configure<cr>", desc = "CMake Generate (configure)", remap = false },
      { "<M-t>cr", "<cmd>Task start cmake run<cr>", desc = "CMake Run", remap = false },
      {
        "<M-t>cs",
        function() cmake_util.select_kit(cmake_args, cmake_args_configure_default) end,
        desc = "CMake Select Kit",
        remap = false,
      },
      { "<M-t>ct", "<cmd>Task set_module_param cmake target<cr>", desc = "CMake Select Target", remap = false },
    }
  end,
}
