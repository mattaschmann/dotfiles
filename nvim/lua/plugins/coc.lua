return {
  'https://github.com/neoclide/coc.nvim',
  branch = 'release',
  config = function()
    -- @Matt TODO: remove coc stuff if you decide to go with the other one
    vim.cmd([[
      " see: https://github.com/neoclide/coc.nvim

      " Make <CR> to accept selected completion item or notify coc.nvim to format
      " <C-g>u breaks current undo, please make your own choice
      inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

      " Use <c-space> to trigger completion.
      inoremap <silent><expr> <c-space> coc#refresh()

      nmap <silent> <F8> <Plug>(coc-diagnostic-next)
      nmap <silent> <S-F8> <Plug>(coc-diagnostic-prev)
      nmap <silent> <Leader>. <Plug>(coc-codeaction-line)
      vmap <silent> <Leader>. <Plug>(coc-codeaction-selected)
      nnoremap <silent> <F2> :CocCommand<CR>
      nnoremap <silent> <F1> :CocList<CR>
      nnoremap <silent> <F7> :CocList diagnostics<CR>

      " Remap keys for gotos
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)

      " docs stuff
      function! ShowDocumentation()
        if CocAction('hasProvider', 'hover')
          call CocActionAsync('doHover')
        else
          call feedkeys('K', 'in')
        endif
      endfunction
      nnoremap <silent> gh :call ShowDocumentation()<CR>

      " Highlight symbol under cursor on CursorHold
      autocmd CursorHold * silent call CocActionAsync('highlight')

      " color config for coc
      highlight CocErrorHighlight guifg=#ff0000
      highlight CocWarningHighlight guifg=#ff922b
      highlight CocInfoHighlight guifg=#95ffa4
      highlight CocInfoSign guifg=#95ffa4
      highlight CocHintHighlight guifg=#15aabf
      highlight CocHighlightText gui=underline
      " Use `:Format` for format current buffer
      command! -nargs=0 Format :call CocAction('format')

    ]])
  end
}
