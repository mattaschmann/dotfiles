
--------------------------------------------------------------------------------
-- lspconfig
--------------------------------------------------------------------------------
-- local lspconfig = require("lspconfig")
-- lspconfig.basedpyright.setup{}

--------------------------------------------------------------------------------
-- null-ls
--------------------------------------------------------------------------------
local null_ls = require('null-ls')
local null_helpers = require('null-ls.helpers')

local cfn_lint = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { 'yaml' },
  generator = null_helpers.generator_factory({
    command = "cfn-lint",
    runtime_condition = function(params)
      -- Only run this if we have a "Resources:" at the root
      for _, v in ipairs(params.content) do
        if v == "Resources:" then return true end
      end
      return false
    end,
    to_stdin = true,
    from_stderr = true,
    args = { "--format", "parseable", "-" },
    format = "line",
    check_exit_code = function(code) return code == 0 or code == 255 end,
    on_output = function(line)
      local row, col, end_row, end_col, code, message = line:match(":(%d+):(%d+):(%d+):(%d+):(%w+):(.+)$")
      local severity = null_helpers.diagnostics.severities['error']
      if message == nil then return nil end

      if vim.startswith(code, "E") then
        severity = null_helpers.diagnostics.severities['error']
      elseif vim.startswith(code, "W") then
        severity = null_helpers.diagnostics.severities['warning']
      else
        severity = null_helpers.diagnostics.severities['information']
      end

      return {
        message = message,
        code = code,
        row = row,
        col = col,
        end_col = end_col,
        end_row = end_row,
        severity = severity,
        source = "cfn-lint",
      }
    end,
  })
}

null_ls.register(cfn_lint)
null_ls.setup({
  debug = true,
})

--------------------------------------------------------------------------------
-- trouble
--------------------------------------------------------------------------------
require('trouble').setup({})


--------------------------------------------------------------------------------
-- nvim-metals
--------------------------------------------------------------------------------
vim.opt_global.shortmess:remove("F")

--------------------------------------------------------------------------------
-- web icons
--------------------------------------------------------------------------------
require('nvim-web-devicons').setup()


--------------------------------------------------------------------------------
-- nvim-tree
--------------------------------------------------------------------------------
local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.del('n', 'S', { buffer = bufnr })
  vim.keymap.del('n', 's', { buffer = bufnr })
  vim.keymap.set('n', '<C-s>', api.tree.search_node, opts('Search'))
  vim.keymap.set('n', '<C-o>', api.node.run.system, opts('Run System'))
end

require('nvim-tree').setup {
  disable_netrw = false,
  hijack_netrw = false,
  on_attach = my_on_attach,
}

-- This is used to close the tree window if it's the only one left
-- see: https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
local function tab_win_closed(winnr)
  local api = require "nvim-tree.api"
  local tabnr = vim.api.nvim_win_get_tabpage(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local buf_info = vim.fn.getbufinfo(bufnr)[1]
  local tab_wins = vim.tbl_filter(function(w) return w ~= winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
  local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
  if buf_info.name:match(".*NvimTree_%d*$") then -- close buffer was nvim tree
    -- Close all nvim tree on :q
    if not vim.tbl_isempty(tab_bufs) then        -- and was not the last window (not closed automatically by code below)
      api.tree.close()
    end
  else                                                    -- else closed buffer was normal buffer
    if #tab_bufs == 1 then                                -- if there is only 1 buffer left in the tab
      local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
      if last_buf_info.name:match(".*NvimTree_%d*$") then -- and that buffer is nvim tree
        vim.schedule(function()
          if #vim.api.nvim_list_wins() == 1 then          -- if its the last buffer in vim
            vim.cmd "Sayonara"                            -- then close all of vim
          else                                            -- else there are more tabs open
            vim.api.nvim_win_close(tab_wins[1], true)     -- then close only the tab
          end
        end)
      end
    end
  end
end

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function()
    local winnr = tonumber(vim.fn.expand("<amatch>"))
    vim.schedule_wrap(tab_win_closed(winnr))
  end,
  nested = true
})

--------------------------------------------------------------------------------
-- leap.nvim
--------------------------------------------------------------------------------
require('leap')
vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')

--------------------------------------------------------------------------------
-- nvim-coverage
--------------------------------------------------------------------------------
require("coverage").setup()

--------------------------------------------------------------------------------
-- local config
--------------------------------------------------------------------------------
require('config-local').setup()
