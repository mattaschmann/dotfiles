-- file tree
return {
  'https://github.com/nvim-tree/nvim-tree.lua',
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {'-', '<cmd>NvimTreeFindFile<cr>'},
    {'<localleader>f', '<cmd>NvimTreeToggle<cr>'},
  },
  config = function()
    local function my_on_attach(bufnr)
      local api = require "nvim-tree.api"

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      local function open_in_yazi()
        local node = api.tree.get_node_under_cursor()
        vim.fn.system { 'tmux', 'split-window', 'yazi', node['absolute_path'] }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.del('n', 'S', { buffer = bufnr })
      vim.keymap.del('n', 's', { buffer = bufnr })
      vim.keymap.set('n', '<C-s>', api.tree.search_node, opts('Search'))
      vim.keymap.set('n', '<C-o>', api.node.run.system, opts('Run System'))
      vim.keymap.set('n', 'y', open_in_yazi, opts('Open in yazi'))
    end

    -- This is used to close the tree window if it's the only one left
    -- see: https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
    -- local function tab_win_closed(winnr)
    --   local api = require "nvim-tree.api"
    --   local tabnr = vim.api.nvim_win_get_tabpage(winnr)
    --   local bufnr = vim.api.nvim_win_get_buf(winnr)
    --   local buf_info = vim.fn.getbufinfo(bufnr)[1]
    --   local tab_wins = vim.tbl_filter(function(w) return w ~= winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
    --   local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
    --   if buf_info.name:match(".*NvimTree_%d*$") then -- close buffer was nvim tree
    --     -- Close all nvim tree on :q
    --     if not vim.tbl_isempty(tab_bufs) then        -- and was not the last window (not closed automatically by code below)
    --       api.tree.close()
    --     end
    --   else                                                    -- else closed buffer was normal buffer
    --     if #tab_bufs == 1 then                                -- if there is only 1 buffer left in the tab
    --       local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
    --       if last_buf_info.name:match(".*NvimTree_%d*$") then -- and that buffer is nvim tree
    --         vim.schedule(function()
    --           if #vim.api.nvim_list_wins() == 1 then          -- if its the last buffer in vim
    --             vim.cmd "Sayonara"                            -- then close all of vim
    --           else                                            -- else there are more tabs open
    --             vim.api.nvim_win_close(tab_wins[1], true)     -- then close only the tab
    --           end
    --         end)
    --       end
    --     end
    --   end
    -- end

    -- vim.api.nvim_create_autocmd("WinClosed", {
    --   callback = function()
    --     local winnr = tonumber(vim.fn.expand("<amatch>"))
    --     vim.schedule_wrap(tab_win_closed(winnr))
    --   end,
    --   nested = true
    -- })

    require('nvim-tree').setup {
      disable_netrw = true,
      hijack_netrw = true,
      on_attach = my_on_attach,
    }

  end
}
