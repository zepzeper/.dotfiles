-- Editing: Org-mode configuration
return {
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = "org",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("orgmode").setup({
        org_agenda_files = { "~/orgfiles/*.org" },
        org_default_notes_file = "~/orgfiles/inbox.org",
        org_capture_templates = {
          w = {
            description = "Work task",
            template = [[
* TODO %? :work:
  CREATED: %U
]],
            target = "~/orgfiles/work.org",
          },
          p = {
            description = "Personal task",
            template = [[
* TODO %?
  CREATED: %U
]],
            target = "~/orgfiles/personal.org",
          },
          i = {
            description = "Inbox",
            template = [[
* TODO %?
  CREATED: %U
]],
            target = "~/orgfiles/inbox.org",
          },
        },
      })
    end,
  },
}
