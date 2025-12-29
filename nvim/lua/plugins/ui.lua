return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
    opts = {
      options = {
        -- globalstatus = false,
        --theme = "kanagawa",
        icons_enabled = true,
      },
      sections = {
        lualine_a = {
          {
            "mode",
            icon = "󰨞",
          },
        },
      },
    },
  },
  -- Mensajes, línea de comando y menú emergente
  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        cmdline = {
          view = "cmdline",
        },
        presets = {
          bottom_search = true, -- Coloca la búsqueda en la parte inferior
          command_palette = true, -- Activa una paleta de comandos
          lsp_doc_border = true, -- Activa un borde para las ventanas emergentes del LSP
        },
      })
    end,
  },
}
