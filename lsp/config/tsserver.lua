local inlayHints = {
  includeInlayEnumMemberValueHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayVariableTypeHints = true,
}

return {
  settings = inlayHints,
  --[[{
    javascript = {
      inlayHints = inlayHints
    },
    typescript = {
      inlayHints = inlayHints
    },
  },]]
}
