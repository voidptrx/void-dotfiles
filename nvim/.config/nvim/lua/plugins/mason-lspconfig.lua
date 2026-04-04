-- local opts = {
--   ensure_installed = {
--     "bashls",
--     "ts_ls",
--     "lua_ls",
--     "rust_analyzer",
--     "jdtls",
--   },
--
--   automatic_installation = true,
-- }

return {
  "mason-org/mason-lspconfig.nvim",
  opts = opts,
  event = "BufReadPre",
}
