"---------------------------------------------------------------
" vim Abbreviations
" ~/.vim/lib/abbr.vim
"______________________________________________________________

func! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

" iabbr <silent> if if ()<Left><C-R>=Eatchar('\s')<CR>


" { 'abbr': '_tre', 'word': '_tre', 'menu':'[bash] Trim Trailing ws', 'info':'Info', 'empty':1 },
let s:abbrmap = []
let s:abbrlist = []

func! NewAbbr(lhs,rhs,...) abort
  execute printf('inoreabbrev <buffer> %s %s',a:lhs,escape(a:rhs,'|\'))
  let l:init_ftc =  's:ft_loaded_'  . getbufvar(bufnr(''), '&filetype')
  if exists(l:init_ftc) | return | endif
  exe 'let ' . l:init_ftc . ' = 1'
  call add(s:abbrlist,a:lhs)
  if a:0 > 0 | call add(s:abbrmap,{'abbr':a:lhs,'word':a:lhs, 'menu': a:1, 'info': a:1, 'empty':1} ) | endif
endfunc


func! GetClipStr(mid)
  let l:txt=system('xsel -b')
  if l:txt=~"\n"
    " contains newline
    return a:mid
  endif
  return l:txt
endfunc

" Completion Item Map
" word : Inserted
" abbr : Label
" menu : Description on rhs
" kind : short tag (f,v,etc.)
" info : Preview Window

" C-n Select Next Item
" C-p Previous Item
" CR  Accept Item
" C-e Cancel Completion
" C-y Accept without Inserting
" Esc Cancel
func! Completefn(findstart, base)


  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\a'
      let start -= 1
    endwhile
    return start
  else
    if len(a:base) == 0 | return s:abbrmap | endif
    let res = []
    let found = 0
    for m in s:abbrlist
      if m =~ '^' . a:base
        let found=1
        call add(res, m)
      endif
    endfor
    return found == 1 ? res : s:abbrmap
  endif
endfunc





set completefunc=Completefn

" <Nul> is <C-Space>
" inoremap <C-space> <C-x><C-u>
inoremap <Nul> <C-x><C-u>

"EOF

