"------------------------------------------------
" Shell (sh,zsh,bash) [ftplugin]
" ~/.vim/ftplugin/sh.vim
"------------------------------------------------

setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal expandtab
let g:func_start = '\w\+\s*(\s*)\s*{'
let g:func_end = '}$'
call NewAbbr('fn!', 'func(){<CR><CR>}<Up>', 'Function [posix]')
call NewAbbr('__z', '[[ -z $ ]]<C-R>=Eatchar(\\s)<CR>' . repeat('<Left>',4),'Var Undefined [posix]')
call NewAbbr('__d', 'if [[ -d ]]; then<CR>echo "Dir "<CR>fi<Up><Right><C-R>=Eatchar(\\s)<CR>' . repeat('<Right>',10),'[posix] Directory Exists' )
call NewAbbr('__f', 'if [[ -f ]]; then<CR>echo "File "<CR>fi<Up><Right><C-R>=Eatchar(\\s)<CR>' . repeat('<Right>',11),'[posix] File Exists' )
call NewAbbr('ife', 'if ! <C-R>=Sh_iferr()<CR>; then<CR>printf "Failed " >&2 && return 1<CR>fi<Up>' . repeat('<Right>',15),'[posix] if else' )
call NewAbbr('_trs', '"${var#"${var%%[![:space:]]*}"}"','[bash] Trim Leading ws' )
call NewAbbr('_tre', '"${var%"${var##*[![:space:]]}"}"', '[bash] Trim Trailing ws')
call NewAbbr('fore!', 'for f in $(<C-R>=GetClipStr("grep -rEnl pat dir/")<CR>); do<CR>echo "File $f"<CR>done<Up><Up>' . repeat('<Right>',12),'[bash] Trim Trailing ws')
"EOF

