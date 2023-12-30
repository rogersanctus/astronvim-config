return {
  "rcarriga/nvim-notify",
  lazy = false,
  opts = {},
  config = function(_, _opts)
    local nvim_notify = require "notify"

    local which_key = require "which-key"

    which_key.register({
      name = "Notifications",
      q = {
        function() nvim_notify.dismiss { pending = true, silent = true } end,
        "Clear Notifications",
        noremap = true,
        nowait = true,
      },
    }, { prefix = "<M-n>" })

    local function my_notify(message, level, notifyOpts)
      local kotlin_ls_annoying_error = "kotlin_language_server: -32603"

      if string.sub(message, 1, string.len(kotlin_ls_annoying_error)) == kotlin_ls_annoying_error then return true end

      nvim_notify.notify(message, level, notifyOpts)
    end

    vim.notify = my_notify
  end,
}
