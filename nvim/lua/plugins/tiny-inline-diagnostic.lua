return {
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require("tiny-inline-diagnostic").setup({
                -- configuration options for tiny-inline-diagnostic
                preset = "ghost",
                options = { use_icons_from_diagnostic = false },
                virtual_text = {
                    prefix = "", -- Prefix for the virtual text
                    spacing = 2, -- Spacing between the prefix and the message
                },
            })
            vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
        end,
    },
}
