return {
    "jellydn/hurl.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        {
            "MeanderingProgrammer/render-markdown.nvim",
            opts = { file_types = { "markdown" } },
            ft = { "markdown" },
        },
    },
    ft = "hurl",
    opts = function()
        local Path = require("plenary.path")
        local Scan = require("plenary.scandir")

        local function find_env_files()
            local filepath = vim.fn.expand("%:p")
            local cwd = vim.fn.fnamemodify(filepath, ":h")
            local parent = Path:new(cwd):parent().filename
            vim.notify("cwd: " .. cwd .. " parent: " .. parent, vim.log.levels.DEBUG)

            local env_files = {}

            local function add_envs_from(dir, isParent)
                local found = Scan.scan_dir(dir, {
                    depth = 1,
                    hidden = true,
                    add_dirs = false,
                    search_pattern = "env",
                })

                for _, f in ipairs(found) do
                    local name
                    if isParent then
                        name = "../" .. Path:new(f):make_relative(dir)
                    else
                        name = Path:new(f):make_relative(cwd)
                    end
                    table.insert(env_files, name)
                    vim.notify("Detected env: " .. name, vim.log.levels.DEBUG)
                end
            end

            add_envs_from(cwd, false)
            add_envs_from(parent, true)

            local unique, seen = {}, {}
            for _, f in ipairs(env_files) do
                if not seen[f] then
                    table.insert(unique, f)
                    seen[f] = true
                end
            end

            return unique
        end

        local envs = find_env_files()

        return {
            debug = false,
            show_notification = false,
            mode = "split",
            formatters = {
                json = { "jq" },
                html = { "prettier", "--parser", "html" },
                xml = { "tidy", "-xml", "-i", "-q" },
            },
            mappings = {
                close = "q",
                next_panel = "<C-n>",
                prev_panel = "<C-p>",
            },
            env_file = envs,
        }
    end,
    keys = {
        { "<leader>tA", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
        { "<leader>ta", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
        { "<leader>te", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
        { "<leader>tE", "<cmd>HurlRunnerToEnd<CR>", desc = "Run Api request from current entry to end" },
        { "<leader>tm", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
        { "<leader>tv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
        { "<leader>tV", "<cmd>HurlVeryVerbose<CR>", desc = "Run Api in very verbose mode" },
        { "<leader>h", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
    },
    config = function(_, opts)
        require("hurl").setup(opts)

        -- función para seleccionar env dinámicamente
        local function pick_env_file()
            vim.ui.select(opts.env_file, {
                prompt = "Selecciona env para Hurl",
            }, function(choice)
                if choice then
                    vim.cmd(("HurlSetEnvFile %s"):format(choice))
                    vim.notify("Hurl: usando " .. choice, vim.log.levels.INFO)
                end
            end)
        end

        vim.keymap.set("n", "<leader>tf", pick_env_file, { desc = "Seleccionar .env para Hurl" })
    end,
}
