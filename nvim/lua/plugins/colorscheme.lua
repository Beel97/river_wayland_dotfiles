return {
    {
        "sekke276/dark_flat.nvim",
        config = function()
            require("dark_flat").setup({
                transparent = true,
            })
        end,
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("cyberdream").setup({
                transparent = true,
                italic_comments = false,
            })
        end,
    },
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            require("onedark").setup({
                style = "darker",
                transparent = true,
                code_style = {
                    comments = "italic",
                    keywords = "none",
                    functions = "none",
                    strings = "none",
                    variables = "none",
                },
                lualine = {
                    transparent = true,
                },
            })
            require("onedark").load()
        end,
    },
}
