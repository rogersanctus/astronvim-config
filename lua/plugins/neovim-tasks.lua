return {
  "Shatur/neovim-tasks",
  main = "tasks",
  lazy = false,
  config = function(_, opts)
    local tasks_config = require "tasks.config"
    local cmake_module = require "tasks.module.cmake"
    local cmake_util = require "utils.cmake"
    local nvim_tasks = require "tasks"
    local which_key = require "which-key"

    local cmake_module_configure = cmake_module.tasks.configure
    local cmake_args = tasks_config.defaults.default_params.cmake.args
    local cmake_args_configure_default = cmake_args.configure

    nvim_tasks.setup {
      default_params = {
        cmake = {
          args = cmake_args,
        },
      },
    }

    which_key.register({
      c = {
        name = "CMake Tasks",
        s = {
          function() cmake_util.select_kit(cmake_args, cmake_args_configure_default) end,
          "CMake Select Kit",
          noremap = true,
          silent = true,
        },
        g = {
          "<cmd>Task start cmake configure<cr>",
          "CMake Generate (configure)",
          noremap = true,
          silent = true,
        },
        b = {
          "<cmd>Task start cmake build<cr>",
          "CMake Build",
          noremap = true,
          silent = true,
        },
        c = {
          "<cmd>Task start cmake clean<cr>",
          "CMake Clean",
          noremap = true,
          silent = true,
        },
        r = {
          "<cmd>Task start cmake run<cr>",
          "CMake Run",
          noremap = true,
          silent = true,
        },
        d = {
          "<cmd>Task start cmake debug<cr>",
          "CMake Debug",
          noremap = true,
          silent = true,
        },
        t = {
          "<cmd>Task set_module_param cmake target<cr>",
          "CMake Select Target",
          noremap = true,
          silent = true,
        },
      },
    }, { prefix = "<M-t>", name = "Tasks" })
  end,
}
