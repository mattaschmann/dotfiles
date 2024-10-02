return {
  'https://github.com/dstein64/nvim-scrollview',
  opts = {
    signs_on_startup = {
      -- 'changelist',   -- change list items (previous, current, and next)
      'conflicts',    -- git merge conflicts
      -- 'cursor',       -- cursor position
      'diagnostics',  -- errors, warnings, info, and hints
      'folds',        -- closed folds
      -- 'latestchange', -- latest change
      'loclist',      -- items on the location list
      'marks',
      'quickfix',     -- items on the quickfix list
      'search',
      'spell',        -- spell check items when the spell option is enabled
      'textwidth',    -- line lengths exceeding the value of the textwidth option, when non-zero
      'trail',        -- trailing whitespace
    },
  },
}

