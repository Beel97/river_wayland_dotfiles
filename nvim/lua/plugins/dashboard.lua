return {
  { "nvimdev/dashboard-nvim", enabled = false },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
██╗   ██╗███████╗ ██████╗ ██████╗ ██████╗ ███████╗
██║   ██║██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔════╝
██║   ██║███████╗██║     ██║   ██║██║  ██║█████╗  
╚██╗ ██╔╝╚════██║██║     ██║   ██║██║  ██║██╔══╝  
 ╚████╔╝ ███████║╚██████╗╚██████╔╝██████╔╝███████╗
  ╚═══╝  ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝
100% Real No Fake And Gluten Free                ]],
        },
        sections = {
          {
            pane = 1,
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
          },
          {
            pane = 2,
            {
              section = "terminal",
              cmd = "pokemon-colorscripts -r --no-title; sleep .1",
              random = 10,
              indent = 4,
              height = 17,
            },

            { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
            --{
            --  icon = " ",
            --  title = "Git Status",
            --  section = "terminal",
            --  enabled = vim.fn.isdirectory(".git") == 1,
            --  cmd = "git status --short --branch --renames; sleep .1",
            --  height = 5,
            --  padding = 1,
            --  ttl = 5 * 60,
            --  indent = 3,
            --},
          },
        },
      },
    },
  },
}
