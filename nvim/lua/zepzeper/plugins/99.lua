return {
    "ThePrimeagen/99",
    config = function()
        local _99 = require("99")

        -- For logging that is to a file if you wish to trace through requests
        -- for reporting bugs, i would not rely on this, but instead the provided
        -- logging mechanisms within 99.  This is for more debugging purposes
        local cwd = vim.uv.cwd()
        local basename = vim.fs.basename(cwd)
        _99.setup({
            logger = {
                level = _99.DEBUG,
                path = "/tmp/" .. basename .. ".99.debug",
                print_on_error = true,
            },

            --- WARNING: if you change cwd then this is likely broken
            --- ill likely fix this in a later change
            ---
            --- md_files is a list of files to look for and auto add based on the location
            --- of the originating request.  That means if you are at /foo/bar/baz.lua
            --- the system will automagically look for:
            --- /foo/bar/AGENT.md
            --- /foo/AGENT.md
            --- assuming that /foo is project root (based on cwd)
            md_files = {
                "AGENT.md",
            },
        })

    end,
}
