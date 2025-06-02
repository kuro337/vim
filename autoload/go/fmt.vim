"---------------------------------------------->
" gofmt Format on Save
" ~/.vim/autoload/go/fmt.vim
"----------------------------------------------<

func! go#fmt#Format()
  w!
  let l:view = winsaveview()
  let l:out = system('gofmt -s -e -w ' . shellescape(expand('%')))
  if v:shell_error != 0
    echohl ErrorMsg
    echo "Error formatting : " . l:out
    echohl None
    return
  endif
  edit
  call winrestview(l:view)
  redraw!
endfunc

"EOF

