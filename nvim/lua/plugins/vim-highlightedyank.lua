-- @Matt TODO: fix the windows yank to clipboard error
return {
  'https://github.com/machakann/vim-highlightedyank',
  config = function()
    vim.g.highlightedyank_highlight_duration = 150
    vim.g.highlightedyank_max_lines = 1000

    vim.cmd([[
      hi HighlightedyankRegion ctermbg=237 guibg=#404040
    ]])
  end
}
