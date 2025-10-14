return {
    {
        "lukas-reineke/indent-blankline.nvim",
        enabled = false,
        event = "VeryLazy",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = {
                enabled = true,
                show_start = true,
                show_end = false,
            },
        },
    }
}
