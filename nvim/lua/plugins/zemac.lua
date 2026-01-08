return {
    "zepzeper/zemac",
    dir = "~/personal/zemac",
    config = function()
        require("zemac").setup({
            win = {
                position = "bottom",  -- "bottom", "top", "left", "right"
                size = 10,            -- Height for bottom/top, width for left/right
            },
        })
    end,
}
