-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.angular" },
  { import = "astrocommunity.pack.cs-omnisharp" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.php" },
  { import = "astrocommunity.pack.blade" },
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.cmake" },
  -- { import = "astrocommunity.pack.haxe" },
  -- { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder
}
