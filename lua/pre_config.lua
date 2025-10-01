vim.filetype.add {
  extension = {
    hx = "haxe",
    hxml = "hxml",
    axaml = "xml",
  },
  pattern = {
    [".*%.blade%.php"] = "blade",
  },
}

-- Return the buffer number for a given filename or -1 if it doesn't exist in the buffer list
local function buf_exists_with_name(name)
  local bufs = vim.api.nvim_list_bufs()

  for _, buf in ipairs(bufs) do
    local buf_name = vim.api.nvim_buf_get_name(buf)

    if buf_name == name then return buf end
  end

  return -1
end

-- Overrides vim.uri_to_bufnr to fix a bug where it can't find the buffer number
vim.uri_to_bufnr = function(uri)
  local fname = vim.uri_to_fname(uri)
  local bufnr = buf_exists_with_name(fname)

  if bufnr == -1 then return vim.fn.bufadd(fname) end

  return bufnr
end
