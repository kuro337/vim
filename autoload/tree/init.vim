"---------------------------------------------->
" tree#init : Initialize netrw Global Commands
" ~/.vim/autoload/tree/init.vim
"----------------------------------------------<
func! tree#init#Netrw()


  let g:lzinit_netrw = 1
  let g:netrw_banner = 0
  let g:netrw_keepdir= 1        " Keep Base Dir Constant
  let g:netrw_winsize= 20
  let g:netrw_liststyle = 3
  let g:netrw_browse_split = 3  " default to new tabs for buffers


  unlet g:loaded_netrwPlugin
  unlet g:loaded_netrw

  exe 'source '.g:vim_home.'/autoload/tree/load_netrw.vim'


endfunc



