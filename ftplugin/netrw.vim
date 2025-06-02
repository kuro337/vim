"------------------------------------------------
" vim [ftplugin]
" ~/.vim/ftplugin/netrw.vim
"------------------------------------------------
let &titlestring = &titlestring

" netrw ft: Overrides for Opening <CR>, Adding (a), Deleting (d)
nnoremap <buffer> <Leader>e :wincmd c<CR>
nnoremap <buffer> <A-,> <C-w>w<CR>:tabprevious<CR>
nnoremap <buffer> <A-.> <C-w>w<CR>:tabnext<CR>
nnoremap <buffer> <silent> a :call tree#fs#New()<CR>
nnoremap <buffer> <silent> % :call tree#fs#New()<CR>
nnoremap <buffer> <silent> <CR> :call tree#fs#Open()<CR>
nnoremap <buffer> d :call tree#fs#Delete()<CR>
"EOF

