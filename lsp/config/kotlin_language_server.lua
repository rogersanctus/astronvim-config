local kls_path =
  vim.fn.expand "$HOME/sources/kotlin-language-server/server/build/install/server/bin/kotlin-language-server"

return {
  cmd = { kls_path },
}
