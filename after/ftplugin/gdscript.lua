local host = "127.0.0.1"
local port = os.getenv "GDScript_Port" or "6005"
-- local pipe = "\\\\.\\pipe\\godot.pipe"
local pipe = [[\\.\pipe\godot.pipe]]
-- local pipe = vim.fn.expand("file:///" .. "$HOME/pipe/godot.pipe")

local int_port = tonumber(port)

if int_port == nil then
  vim.notify("Godot LSP client: Invalid server port number: " .. port, vim.log.levels.ERROR)
  return
end

-- local cmd = vim.lsp.rpc.connect(host, int_port)
local cmd = { "ncat", host, port }

-- local cmd_nvim = [[nvim --headless --server "]] .. pipe .. [[" --remote-send "<C-\\><C-N>:echo 'running'<CR>"]]
-- --
-- vim.fn.jobstart(cmd_nvim, {
--   on_stdout = function(id, data, name)
--     local out = vim.inspect(data)
--     print(out)
--
--     vim.notify(out, vim.log.levels.INFO)
--   end,
-- })

vim.lsp.start {
  name = "Godot",
  cmd = cmd,
  root_dir = vim.fs.dirname(vim.fs.find({ "project.godot", ".git" }, { upward = true })[1]),
  on_attach = function(client, bufnr)
    local servers = vim.fn.serverlist()

    -- if vim.contains(servers, pipe) then
    --   print "Contains!"
    -- else
    --   print "Not contains!"
    -- end
    print(servers)
    print(type(servers))

    local check = vim.tbl_contains(servers, function(checking)
      print("check", checking)
      print("pipe", pipe)
      return checking == pipe
    end)

    -- vim.notify(vim.inspect(servers), vim.log.levels.INFO)
    -- print(check)
    -- print(pipe)

    -- local cmd_nvim = [[nvim --headless --server "]] .. pipe .. [[" --remote-send "<C-\\><C-N>:echo 'running'<CR><CR>"]]
    -- --
    -- vim.fn.jobstart(cmd_nvim, {
    --   on_stdout = function(id, data, name)
    --     local out = vim.inspect(data)
    --     print(out)
    --
    --     vim.notify(out, vim.log.levels.INFO)
    --   end,
    -- })

    print "attached"

    vim.api.nvim_command([[echo serverstart(']] .. pipe .. [[')]])
  end,
  -- on_attach = function(client, bufnr) vim.api.nvim_command("echo serverstart('" .. pipe .. "')") end,
}
