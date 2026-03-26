-- Run format on current buffer (now being handled by conform.lua)
-- vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format() end, {desc='Run lsp format on current buffer'})

-- Toggle between @Matt and @Agent
local MattAgentToggle = {}
function MattAgentToggle:toggle()
  local current_line = vim.api.nvim_get_current_line()
  local pos = string.find(current_line, '@Matt')
  local pos2 = string.find(current_line, '@Agent')

  if pos then
    -- Replace @Matt with @Agent
    local new_line = string.gsub(current_line, '@Matt', '@Agent')
    vim.api.nvim_buf_set_lines(
      0,
      vim.api.nvim_win_get_cursor(0)[1] - 1,
      vim.api.nvim_win_get_cursor(0)[1],
      false,
      { new_line }
    )
  elseif pos2 then
    -- Replace @Agent with @Matt
    local new_line = string.gsub(current_line, '@Agent', '@Matt')
    vim.api.nvim_buf_set_lines(
      0,
      vim.api.nvim_win_get_cursor(0)[1] - 1,
      vim.api.nvim_win_get_cursor(0)[1],
      false,
      { new_line }
    )
  end
end
vim.keymap.set('n', '<localleader>m', MattAgentToggle.toggle, { noremap = true, silent = true })
