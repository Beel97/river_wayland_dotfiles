return {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        themes = {"dark_flat","cyberdream","onedark"},
        livePreview = true,
      })
    end
  }
