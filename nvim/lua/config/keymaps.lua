-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--Desactivar mouse
vim.opt.mouse = ""

-- Desactiva las teclas de flechas en el modo normal
vim.keymap.set("n", "<Up>", "<nop>")
vim.keymap.set("n", "<Down>", "<nop>")
vim.keymap.set("n", "<Left>", "<nop>")
vim.keymap.set("n", "<Right>", "<nop>")

-- Desactiva las teclas de flechas en el modo de inserción
vim.keymap.set("i", "<Up>", "<nop>")
vim.keymap.set("i", "<Down>", "<nop>")
vim.keymap.set("i", "<Left>", "<nop>")
vim.keymap.set("i", "<Right>", "<nop>")

-- Desactiva las teclas de flechas en el modo visual
vim.keymap.set("v", "<Up>", "<nop>")
vim.keymap.set("v", "<Down>", "<nop>")
vim.keymap.set("v", "<Left>", "<nop>")
vim.keymap.set("v", "<Right>", "<nop>")

--vim.keymap.set("n", "<leader>k", "<cmd>LazyDocker<CR>", { desc = "Toggle LazyDocker", noremap = true, silent = true })

---sort lines
vim.keymap.set("v", "<leader>cs", "<cmd>'<, '>sort<CR>", { desc = "Sort lines", noremap = true, silent = true })

-- Obsidian.nvim keymaps
-- Nota: todos bajo <leader>o para mantenerlos organizados
-- 📂 Notas
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", { desc = "Open note" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "New note" })
vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Quick switch" })
vim.keymap.set("n", "<leader>of", "<cmd>ObsidianFollowLink<CR>", { desc = "Follow link" })
vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianLinks<CR>", { desc = "List links in buffer" })
vim.keymap.set("v", "<leader>oi", ":ObsidianLink<CR>", { desc = "Link selection to note" })
vim.keymap.set("v", "<leader>oI", ":ObsidianLinkNew<CR>", { desc = "Link selection → New note" })
vim.keymap.set("v", "<leader>oe", ":ObsidianExtractNote<CR>", { desc = "Extract selection to note" })

-- 🔎 Búsqueda y navegación
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search notes" })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Backlinks" })
vim.keymap.set("n", "<leader>otg", "<cmd>ObsidianTags<CR>", { desc = "Search tags" })
vim.keymap.set("n", "<leader>otc", "<cmd>ObsidianTOC<CR>", { desc = "Table of contents" })

-- 📅 Notas diarias
vim.keymap.set("n", "<leader>od", "<cmd>ObsidianToday<CR>", { desc = "Today" })
vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<CR>", { desc = "Yesterday" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTomorrow<CR>", { desc = "Tomorrow" })
vim.keymap.set("n", "<leader>ods", "<cmd>ObsidianDailies<CR>", { desc = "List dailies" })

-- 📝 Templates
vim.keymap.set("n", "<leader>otm", "<cmd>ObsidianTemplate<CR>", { desc = "Insert template" })
vim.keymap.set("n", "<leader>onf", "<cmd>ObsidianNewFromTemplate<CR>", { desc = "New note from template" })
vim.keymap.set("n", "<leader>onn", "<cmd>ObsidianNew<CR>", { desc = "New note blank" })

-- 🖼️ Multimedia
vim.keymap.set("n", "<leader>op", "<cmd>ObsidianPasteImg<CR>", { desc = "Paste image" })

-- ⚙️ Gestión
vim.keymap.set("n", "<leader>ow", "<cmd>ObsidianWorkspace<CR>", { desc = "Switch workspace" })
vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<CR>", { desc = "Rename note" })
vim.keymap.set("n", "<leader>ox", "<cmd>ObsidianToggleCheckbox<CR>", { desc = "Toggle checkbox" })

-- themery
vim.keymap.set("n", "<leader>ut", "<cmd>Themery<CR>", { desc = "Themery" })
