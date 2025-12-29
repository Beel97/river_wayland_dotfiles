-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.number = false
vim.opt.relativenumber = true

--Themes
--vim.cmd.colorscheme('dark_flat')
vim.g.autoformat = false
vim.g.editorconfig = true

--Spelling
vim.opt.spell = true
vim.opt.spelllang = { "en_us", "es_mx" }

vim.g.lazyvim_picker = "fzf"

vim.g.mkdp_auto_close = 0

vim.filetype.add({
    pattern = {
        [".*%.blade%.php"] = "blade",
    },
})
