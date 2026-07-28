local CMP = require("cmp")

CMP.setup({
    snippets = { preset = "default" },
    signature = { enabled = true },
    appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "normal",
    },
    cmdline = {
        enabled = false,
        completion = { menu = { auto_show = true } },
    },
    completion = {
        menu = {
            border = "rounded",
            scrolloff = 1,
            scrollbar = false,
            draw = {
                padding = 1,
                gap = 1,
                columns = {
                    { "kind_icon" },
                    { "label", "label_description", gap = 1 },
                    { "kind" },
                    { "source_name" },
                },
            },
        },
        documentation = {
            window = {
                border = "rounded",
                scrollbar = false,
                winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
            },
            auto_show = true,
            auto_show_delay_ms = 500,
        },
    },
    mapping = {
        ["<C-n>"] = CMP.mapping.select_next_item(),
        ["<C-p>"] = CMP.mapping.select_prev_item(),
        ["<C-y>"] = CMP.mapping.confirm({ select = true }),
    },
    performance = {
        debounce = 50,
    },
    sources = CMP.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "buffer" },
        { name = "path" },
    }),
})
