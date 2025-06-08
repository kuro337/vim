"-------------------------------------
" Vim Util Functions
" ~/.vim/lib/func.vim
"-------------------------------------

"### String Matching ###
" s =~   'rgx'   : matched
" s !~   'rgx'   : no match
" s =~?  'rgx'   : case insensitive match
" s !~?  'rgx'   : failed match

" Check if a Path Exists
func! PathValid(p)
  if !empty(glob(a:p)) | return 1 | endif
endfunc

" Create a Public Dir. Default is 0777 & ~umask = 0755 (owner only)
func! Mkdir(p)
  call system('mkdir -p -m 700 ' . shellescape(a:p))
endfunc


"---------------------------
" System Clipboard, Yanking
"--------------------------
" Highlight the Yanked Region
func! s:HlYankRegion()
  let lnum = line("'[")
  let lend = line("']")
  if lnum <= 0 || lend <= 0 | return | endif
  execute 'match YankRegion /\%>' . (lnum - 1) . 'l\%<' . (lend + 1) . 'l/'
  silent! redraw
  sleep 300m
  match none
endfunc

" Copy Unnamed Register to System Clipboard
func! s:YankReg()
  call system('xsel -ib', substitute(getreg('"'),'\n\+$','',''))
endfunc

" Yank vim Register to System Register & Highlight Region
func! s:CopyRegToClip()
  call system('xsel -ib', substitute(getreg('"'),'\n\+$','',''))
  call <SID>HlYankRegion()
endfunc

" append inserts lines below provided lnum
" Paste from System Clipboard & Remove leading,trailing ws & clear \r win carriage
func! <SID>GetClip()
  let l:pos =  getpos('.')
  let l:lnum = l:pos[1]
  let l:col = l:pos[2]
  let l:txt = split(substitute(substitute(system('xsel -b'),'^\s*\|\s*$', '', 'g'),'\r', '', 'g'), "\n")
  let l:ln = getline(l:lnum)

  " if @ empty line, Insert Lines as is
  if len(trim(l:ln)) == 0
    call append(l:lnum - 1, l:txt)
    call feedkeys("\<BS>",'in')
    return
  endif

  " If at Last Col, append or insert in the Middle
  if len(l:ln) <= l:col
    call setline(l:lnum, l:ln . remove(l:txt,0))
  else
    call setline(l:lnum,strpart(l:ln,0,l:col-1) . remove(l:txt,0) . strpart(l:ln,l:col-1))
  endif

  if empty(l:txt) | call append(l:lnum, l:txt)| endif
endfunc

" yy and Y - copy to system clipboard
nnoremap <silent> yy :<C-u>normal! yy<CR>:call <SID>CopyRegToClip()<CR>
nnoremap <silent> Y :<C-u>normal! Y<CR>:call <SID>CopyRegToClip()<CR>
xnoremap <silent> y y:call <SID>CopyRegToClip()<CR>

" Yank anything in unnamed reg to System Clipboard
xnoremap <silent> <leader>y :<C-u><SID>CopyRegToClip()<CR>
xnoremap <silent> c y:call system('xsel -ib', substitute(getreg('"'),'\n\+$','',''))<CR>gvc

" Paste to System clipboard
nnoremap <leader>p :call <SID>GetClip()<CR>
inoremap  <A-v> <C-o>:call <SID>GetClip()<CR>
" inoremap  <A-v> <C-o>:call <SID>GetClip()<CR><BS>

function! ToggleComment()
  " Get the comment string
  let l:comment = split(&commentstring, '%s')[0]

  " If no comment string is defined, use // as default
  if empty(l:comment)
    let l:comment = '//'
  endif

  " Get the current line
  let l:line = getline('.')

  " Check if line is already commented
  if l:line =~ '^\s*' . escape(l:comment, '/*')
    " Uncomment: remove comment and one space after if exists
    execute 's/^\(\s*\)' . escape(l:comment, '/*') . '\s\?/\1/'
  else
    " Comment: Add comment at start of line after any whitespace
    execute 's/^\(\s*\)/\1' . escape(l:comment, '/*') . ' /'
  endif
endfunction



" Toggle-current line
" NOTE: Use '_' instead of / for xterm/gnome
nnoremap <C-/> :call ToggleComment()<CR>
xnoremap <C-/> :call ToggleComment()<CR>
if has('mac')                            
  nnoremap <D-/> :call ToggleComment()<CR>
  xnoremap <D-/> :call ToggleComment()<CR>
else
  nnoremap <C-_> :call ToggleComment()<CR>
  xnoremap <C-_> :call ToggleComment()<CR>
endif



func! <SID>CurrPaths(...)
  let delim = a:0 == 0 ? ',' : a:1
  if delim == 'n' || delim == '\n'
    let delim = "\n"
  endif
  let names=[]
  for buf in getbufinfo({'buflisted':1})
    if buf.name != ""
      call add(names, buf.name)
    endif
  endfor

  call system("xsel -ib", join(names,delim))
endfunc


" :Path - Yank current Path to System Clipboard
func! <SID>CurrPath()
  let l:path = expand('%:p')
  call system("xsel -ib", l:path)
  let @" = l:path
endfunc
command! Path call <SID>CurrPath()


func! <SID>CreateFile(file)
  call Log('passed: ' . a:file)

  let l:dir = fnamemodify(a:file,':h')

  if !isdirectory(l:dir)
    if !input(l:dir . ' -> create dir?') ==# "y" | return | endif
    call mkdir(l:dir,'p')

    " let l:confirm = input(l:dir . ' -> create dir?')

    " if l:confirm ==# "y"
    " call mkdir(l:dir,'p')
    " else
    " return
    " endif
  endif

  tabnew
  exe 'edit' fnameescape(a:file)
endfunc


command! -nargs=1 Mkf call <SID>CreateFile(<f-args>)


command! -nargs=? Paths call <SID>CurrPaths(<f-args>)


command! SaveNoEol call s:SaveNoEol()
func! s:SaveNoEol()
  let l:formatoptions_save=&formatoptions
  let l:equalprg_save=&equalprg
  let l:autocmds_save=&eventignore
  let l:fixeol_save=&fixeol
  let l:eol_save=&eol
  setlocal formatoptions-=ro
  setlocal equalprg=
  set eventignore=BufWritePre,BufWritePost

  setlocal noeol nofixeol
  write

  let &formatoptions=l:formatoptions_save
  let &equalprg=l:equalprg_save
  let &eventignore=l:autocmds_save
  let &eol=l:eol_save
  let &fixeol=l:fixeol_save

  " set noeol nofixeol

endfunc


" Smart tab for completion: if prev char keyword, or start of line, use Literal Tab 
func! Smart_tab()
  let col = virtcol('.') - 1
  return !col || getline('.')[col - 1] !~ '\k' ? "\<Tab>" : "\<C-n>"
endfunc

command! DiffWins windo set foldmethod=diff | normal! zM
command! -nargs=? DiffBranch call s:DiffBranch(<f-args>)

command! Bdiff diffthis | rightbelow vnew | set bt=nofile | r ++edit # | 0d_ | diffthis | let &ft=getbufvar('#', '&ft') | let &l:winbar=expand('#:t') . ' (saved)'",


func! s:DiffBranch(...)
  let l:filepath=expand('%')
  if empty(l:filepath) || !filereadable(l:filepath)
    echoerr "No file to compare."
    return
  endif

  let l:br=get(a:000,0,'')
  if empty(l:br) || l:br ==# 'u'
    let l:br=get(systemlist('git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null'),0,'')
    if empty(l:br)
      echoerr "No Upstream tracking found"
      return
    endif
  endif

  let l:ft=&filetype
  let l:tempfile=tempname()

  call system('git show ' . shellescape(l:br . ':' . l:filepath) . ' > ' . shellescape(l:tempfile))
  if v:shell_error
    echoerr "Failed to load File from Branch: " . l:br
    return
  endif

  rightbelow vert new

  setlocal buftype=
  silent! execute 'edit ' . fnameescape(l:tempfile)
  setlocal readonly
  setlocal nomodifiable

  execute 'set filetype=' . l:ft
  execute 'file [branch:' . l:br . ']'
  diffthis
  wincmd p
  diffthis
  nnoremap <buffer> <Leader>q :qa!<CR>
endfunc


" Git file status
let g:git_file_status = ''

func! GitFileStatus()
  if empty(g:git_branch_name)
    let g:git_file_status = ''
    return
  endif
  let file = expand('%:t')
  if empty(file)
    let g:git_file_status = ''
    return
  endif
  let command = "cd \"" . expand('%:p:h') . "\" && git status --short 2>/dev/null"

  let modifier = system(command . " | grep '" . file . "$' | awk -F' ' '{printf \"%s\", $1}'")
  if empty(modifier)
    let g:git_file_status = ''
  else
    let g:git_file_status = modifier
  endif
endfunction

" Git branch name
let g:git_branch_name = ''
func! GitBranchName()
  let command = "cd \"" . expand('%:p:h') . "\" && git symbolic-ref --short HEAD 2>/dev/null"
  " Use last part if branch name separated by '/'
  let branch = system(command . " | awk -F'/' '{printf \"%s\", $NF}'")
  if empty(branch)
    let g:git_branch_name = ''
  else
    let branch = substitute(branch, '\n\+$', '', '')

    let g:git_branch_name =  branch . ' '
  endif
endfunc




let g:vlogs = []

func! FLog(...)
  if len(a:000) > 1
    call add(g:vlogs, call('printf',a:000))
    return
  endif

  if len(a:000) == 1
    call add(g:vlogs,a:000[0])
    return
  endif
endfunc


func! Log(m)
  call add(g:vlogs, a:m)
endfunc

func! <SID>PrintLogs()
  for line in g:vlogs
    echom line
  endfor
endfunc


command! Logs call <SID>PrintLogs()

" nnoremap <C-m> :call PrintLogs()<CR>


" SyncStack shows the current syntax highlight group stack.
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  echo map(synstack(line('.'), col('.')), 'synIDattr(synIDtrans(v:val), "name")')
endfunc


func! FindFuncRange()
  if !exists('g:func_start') || !exists('g:func_end') | return | endif

  " Find start
  let l:start = line('.')
  while l:start > 0


    if getline(l:start) =~? '^' . g:func_start | break | endif


    let l:start -= 1
  endwhile

  if l:start == 0 | return | endif

  " if getline(l:start) !~? '^func!'
  " return
  " endif


  let l:end = line('$')

  let l:pos = l:start

  while l:pos <= l:end

    " if getline(l:pos) =~? '^endfunc' | break | endif

  if getline(l:pos) =~? '^' . g:func_end | break | endif


  " if getline(l:pos) =~? '^endfunc'
  " break
  " endif
  let l:pos += 1
endwhile


if l:pos > l:end | return | endif

" if l:pos > l:end
" return
" endif


call FLog('Found start: %d, end: %d',l:start,l:pos)

call cursor(l:start,1)
normal! v

" exe l:start . "normal! V"

call cursor(l:pos,7)
" exe 'normal! ' (l:pos - l:start) . "j"
" exe (l:pos - l:start) . "j"

endfunc

nnoremap <silent> vfo :call FindFuncRange()<CR>



" inserting cmd line expr into buffer: :put =<expr>

" : put =expand('%:p')



