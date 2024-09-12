return {
  -- git gutter
  'https://github.com/airblade/vim-gitgutter',
  config = function()
    vim.cmd([[
      nmap <LocalLeader>hp <Plug>(GitGutterPreviewHunk)
      nmap <LocalLeader>hs <Plug>(GitGutterStageHunk)
      nmap <LocalLeader>hu <Plug>(GitGutterUndoHunk)
      autocmd BufEnter,FocusGained * GitGutter " reload gitgutter on focus
      let g:gitgutter_preview_win_floating = 0
    ]])
  end
}
