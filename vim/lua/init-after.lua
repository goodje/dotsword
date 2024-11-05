-- this file is loaded after the plugins are loaded


-- autocomplete

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
)
require("cmp_git").setup() ]]



-- Golang
-- local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
--  vim.api.nvim_create_autocmd("BufWritePre", {
--    pattern = "*.go",
--    callback = function()
--     require('go.format').goimports()
--    end,
--    group = format_sync_grp,
--  })
--
--  local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
--  vim.api.nvim_create_autocmd("BufWritePre", {
--    pattern = "*.go",
--    callback = function()
--     require('go.format').goimports()
--    end,
--    group = format_sync_grp,
--  })


