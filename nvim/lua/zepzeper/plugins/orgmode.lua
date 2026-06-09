local base_template = [[
* TODO %?
  CREATED: %U
]]

local work_template = [[
* TODO %? :work:
  CREATED: %U
]]

require('orgmode').setup({
  org_agenda_files = { '~/orgfiles/*.org' },
  org_default_notes_file = '~/orgfiles/inbox.org',

  org_capture_templates = {
    w = {
      description = 'Work task',
      template = work_template,
      target = '~/orgfiles/work.org',
    },

    p = {
      description = 'Personal task',
      template = base_template,
      target = '~/orgfiles/personal.org',
    },

    i = {
      description = 'Inbox',
      template = base_template,
      target = '~/orgfiles/inbox.org',
    },
  },
})
