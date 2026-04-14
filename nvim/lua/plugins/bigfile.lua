return {
  "LunarVim/bigfile.nvim",
  event = "BufReadPre",
  opts = {
    filesize = 2, -- MiB
    pattern = { "*" },
    features = {
      "indent_blankline",
      "illuminate",
      "lsp",
      "treesitter",
      "syntax",
      "matchparen",
      "vimopts",
      "filetype",
    },
  },
  config = function(_, opts)
    -- Add custom feature to disable spell
    local bigfile = require("bigfile")
    local custom_features = {
      name = "disable_spell",
      opts = { defer = false },
      disable = function()
        vim.opt_local.spell = false
      end,
    }
    table.insert(opts.features, custom_features)
    bigfile.setup(opts)
  end,
}
