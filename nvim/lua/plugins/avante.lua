return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  opts = {
    provider = "ollama",
    auto_suggestions_provider = "ollama",
    providers = {
      gemini = {
        model = "gemini-1.5-flash",
        temperature = 0,
        max_tokens = 4096,
      },
      ollama = {
        __inherited_from = "openai",
        api_key_name = "",
        endpoint = "http://127.0.0.1:11434/v1",
        model = "qwen3.5:4b",
        temperature = 0,
        max_tokens = 4096,
      },
    },
    behaviour = {
      auto_suggestions = true,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true,
    },
    mappings = {
      ask = "<leader>aa",
      edit = "<leader>ae",
      refresh = "<leader>ar",
      diff = {
        ours = "co",
        theirs = "ct",
        all_theirs = "ca",
        both = "cb",
        cursor = "cc",
        next = "]x",
        prev = "[x",
      },
      suggestion = {
        accept = "<C-l>", -- Ahora usas Ctrl+l para aceptar (evita conflictos con Enter)
        next = "<M-j>",   -- Alt+j para siguiente sugerencia
        prev = "<M-k>",   -- Alt+k para anterior sugerencia
        dismiss = "<C-h>", -- Ctrl+h para descartar
      },
    },
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = { file_types = { "markdown", "Avante" } },
      ft = { "markdown", "Avante" },
    },
    {
      "folke/which-key.nvim",
      optional = true,
      opts = {
        spec = {
          { "<leader>a", group = "ai" },
          { "<leader>aa", desc = "Avante Ask" },
          { "<leader>ae", desc = "Avante Edit" },
          { "<leader>ar", desc = "Avante Refresh" },
          { "<leader>ac", "<cmd>AvanteClear<cr>", desc = "Clear Chat History" },
          { "<leader>as", "<cmd>AvanteSwitchProvider<cr>", desc = "Switch AI Provider" },
          { "<leader>ag", desc = "Fix Grammar & Spelling" },
        },
      },
    },
  },
  config = function(_, opts)
    require("avante").setup(opts)
    
    -- Atajo directo para corregir gramática y ortografía en modo visual
    vim.keymap.set("v", "<leader>ag", function()
      require("avante.api").edit("Mejora la gramática y la ortografía de este texto, manteniendo un estilo natural.")
    end, { desc = "Avante: Fix Grammar/Spelling" })
  end,
}
