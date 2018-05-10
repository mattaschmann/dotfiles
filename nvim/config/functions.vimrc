" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction
function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

" Split helpers
function! MoveBufferRightSplit()
  let @s = &splitright
  let &splitright = 0
  vsp +bp
  wincmd l
  let &splitright = @s
endfunction
function! MoveBufferLeftSplit()
  let @s = &splitright
  let &splitright = 1
  vsp +bp
  wincmd h
  let &splitright = @s
endfunction
function! MoveBufferBottomSplit()
  let @s = &splitbelow
  let &splitbelow = 0
  sp +bp
  wincmd j
  let &splitbelow = @s
endfunction
function! MoveBufferTopSplit()
  let @s = &splitbelow
  let &splitbelow = 1
  sp +bp
  wincmd k
  let &splitbelow = @s
endfunction

" open file and directory in code
command! Code
  \ :!code . %
