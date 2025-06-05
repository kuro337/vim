"------------------------------------------------
" vim [ftplugin]
" ~/.vim/ftplugin/vim.vim
"------------------------------------------------

" == case insensitive, ==# case sensitive

" Markers for func start/end for Text Objects
let g:func_start = 'func!'
let g:func_end =  'endfunc'

call NewAbbr('usr!', 'command! -nargs=? Paths call s:CurrPaths(<f-args>)<CR>','vim UserCommand')
call NewAbbr('au!', 'autocmd BufWritePre *.go redraw!','vim AutoCommand')
call NewAbbr('fn!', 'func! Func()<CR>call system("xsel -ib", "stdin args")<CR>endfunc','vim func')
call NewAbbr('fn!', 'func! Func()<CR>call system("xsel -ib", "stdin args")<CR>endfunc','vim func')
call NewAbbr('if!', 'if g:var ==# "y" | call Func() | endif','if shorthand')
call NewAbbr('ife!', 'if var == "y"<CR>echomsg " "<CR>endif<Up>' . repeat('<Right>',8),'if else')
  "EOF

