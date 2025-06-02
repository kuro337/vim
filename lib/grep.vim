"---------------------------------------------------------------
" vim Grep
" ~/.vim/lib/grep.vim
"______________________________________________________________

func! VGrep(term)
  let l:winid = win_getid()
  let l:bufnr = bufnr('%')
  exe 'silent! vimgrep /' . escape(a:term,'/') . '/ **/*'
  copen
  call win_gotoid(l:winid)
  if bufnr('%') != l:bufnr
    execute 'buffer ' . l:bufnr
  endif
endfunc


command! -nargs=1 Grep call VGrep(<q-args>)

augroup quickfix
  autocmd!
  autocmd FileType qf nnoremap <buffer> <CR> :tab drop <cfile><CR>
  autocmd FileType qf nnoremap <buffer> q :cclose<CR>
augroup END

"EOF
