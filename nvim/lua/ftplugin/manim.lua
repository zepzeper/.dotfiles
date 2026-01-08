local M = {}

local function get_class_name()
  local node = vim.treesitter.get_node()
  while node do
    if node:type() == "class_definition" then
      local name_node = node:field("name")[1]
      if name_node then
        local class_name = vim.treesitter.get_node_text(name_node, 0)
        return class_name
      end
    end
    node = node:parent()
  end
  return nil
end

local function render_scene()
  local class_name = get_class_name()
  if not class_name then
    print("No class name found at cursor!")
    return
  end
  local file_path = vim.fn.expand('%:p')
  local dir_name = vim.fn.expand('%:p:h')
  local file_name = vim.fn.expand('%:t:r')
  local video_path = dir_name .. '/media/videos/' .. file_name .. '/480p15/' .. class_name .. '.mp4'
  
  local cmd = string.format("python -m manim -ql '%s' '%s' && mpv '%s'", file_path, class_name, video_path)
  
  Snacks.terminal(cmd)
end

vim.keymap.set("n", "<leader>mm", render_scene, { noremap = true, silent = true })

return M
