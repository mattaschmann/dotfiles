--------------------------------------------------------------------------------
-- null-ls
--------------------------------------------------------------------------------
local null_ls = require('null-ls')
local null_helpers = require('null-ls.helpers')

local cfn_lint = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = {'yaml'},
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
