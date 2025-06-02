" set this file as in ~/.vimrc
" any themes in ~/.vim/colors/>theme>.vim
" NOTE: Use Shift + Mouse for Selecting ex cmd output
" Use Ctrl instead of Cmd, Terminal vim does not support MacOS Command

" OLD vimrc file, ignore
" Set encoding
scriptencoding utf-8
set encoding=utf-8
set nocompatible " Turn off Vi-compatible mode to enable modern features


set termguicolors
set t_Co=256 " Set 256 colors

let g:did_install_default_menus = 1  " avoid stupid menu.vim (saves ~100ms)
let g:loaded_netrwPlugin = 0  " Disable netrw. 🚮

" Modelines
" set modeline
" set modelines=1
set nomodeline " Disable mode lines for security reasons. e.g Prevents code like # vim: !rm x-rf

" Turn off audio bell & visual bell
set visualbell 
set belloff=all
set mouse=a " Enable Mouse Support All modes

" Set <Leader> for commands "
let mapleader = " " 

" Backspace <BS> allowance
" indent - backspacing over autoindent
" eol - backspacing over line break (join lines)
" start - backspacing over start of insert
"set backspace=eol
set backspace=indent,eol,start  " This is most common setting

" Smart Backspace in normal mode
" If at the beginning of the line will join to previous
" else will delete character
nnoremap <Backspace> :<C-u>if virtcol('.') == 1 \| execute "normal! kJ" \| else \| execute "normal! X" \| endif<CR>



" yank full buffer
nnoremap yY :let b:winview=winsaveview()<bar>exe 'keepjumps keepmarks norm ggVG"+y'<bar>call winrestview(b:winview)<cr>

" copy selection to gui-clipboard
xnoremap Y "+y 

cnoremap <M-%> <c-r>=fnamemodify(@%, ':t')<cr>
cnoremap <M-5> <c-r>=fnamemodify(@%, ':t')<cr>
noremap! <m-/> <c-r>=expand('%:p:h', 1)<cr>

cnoremap <expr> <BS> (getcmdtype() =~ '[/?]' && getcmdline() == '') ? '\v^(()@!.)*$<Left><Left><Left><Left><Left><Left><Left>' : '<BS>'

" Repeat last command for each line of a visual selection.
xnoremap . :normal .<CR>

set wildcharm=<C-Z>
set wildoptions+=fuzzy


" Shift+Enter doesn't work in macOS Terminal out of the box

if has('clipboard')
    set clipboard=unnamed
endif

set number " Show line numbers

" Show line and column numbers
" set ruler
" Show entered command in last line
set showcmd
" Show mode (insert, visual) in last line
set showmode
" Show paired braces
set showmatch
" Timeout for mapping delays
set timeoutlen=1000
" Timeout for key code delays
set ttimeoutlen=10

"set nobackup  " Immediately delete backup files
"set nowritebackup " Don't create backup before writing, this option overridden by backup below
" set swapfile " Turn on swap files
" To avoid creating too much swap files open them in read-only mode: vim -R <file>, or view <file>
" set directory^=$HOME/.vim/tmp//  " Keep all swap files in one place

set noswapfile " Turn off swap files
set backup " Create backup before writing and keep backup files (will be overwritten on future backups)
" Keep all backups in given place
set backupdir^=$HOME/.vim/tmp//
set exrc " Allow .nvimrc / .exrc files in cwd
set cpoptions-=_ "Removes _ from compat options

" Persistent undo across sessions
set undofile
set undodir^=$HOME/.vim/tmp//
" Undo points
" By default undo reverts everything since entering insert mode
inoremap <Enter> <Enter><C-g>u
inoremap . .<C-g>u
inoremap , ,<C-g>u
inoremap ; ;<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

" Reload file on changes
set autoread
" Write file before :make (and other commands or quit)
set autowriteall

" Automatic sessions
" Will open last position when reopening files
" Specify where session scripts are stored
set viewdir=$HOME/.vim/tmp//
" This is important to have modeline work together with view sessions
set viewoptions-=options
set sessionoptions-=options

" Split behaviour
" sp <filename> will open in bottom view
set splitbelow
" vsp <filename> will open in right view
set splitright

" Reload configuration on .vimrc save
"au! BufWritePost $MYVIMRC source %

" To replace all tabs to spaces in the opened file, just run:
" :%retab

" Indents will have a width of 2,  softtabstop: Number of columns for a tab
set expandtab shiftwidth=2 softtabstop=-1 "expand tabs to spaces, 2 spaces for autoindent, softtabstop -1 follows shiftwidth
set autoindent
set smartindent
set smarttab

"set listchars=tab:\ \,trail:·,precedes:⇇,extends:⇉,nbsp:␣,eol:¬
" preserve settings and only change if not set
autocmd FileType * autocmd CursorMoved * ++once if !&expandtab | setlocal listchars+=tab:\ \  | endif
set list " Show tabs, trail and non-break spaces

" q to close help buffers
autocmd FileType help nnoremap <buffer> q :quit<CR> 


set nostartofline " Prevents moving the cursor to the start of the line when switching buffers or jumping.
set nowrap

" Wrap mode helpers

" Go to next/prev line using h and l
set whichwrap+=<,>,h,l

" Go to the next character visually below current one
nnoremap <expr> j v:count ? 'j' : 'gj'
" Go to the next character visually above current one
nnoremap <expr> k v:count ? 'k' : 'gk'

" Simulate soft wrap at 80
nnoremap <Leader>v :vnew \| wincmd p \| vertical res 80<CR>

" Search for trailing whitespaces
nnoremap <Leader>ws :/\s$<Enter>

" Spelling
" ]s - next misspelled word
" [s - previous misspelled word
" z= - show suggestions
" zg - add word as 'good' into spellfile
" zw - add word as 'wrong' into spellfile
if has("spell")
    " Spelling
    "nnoremap z= <cmd>setlocal spell spelllang=en_us<CR>z=
    function! EnableSpellCheck()
        if !&spell
            setlocal spell spelllang=en_us
        endif
    endfunction

    " Map `z=` to enable spell dynamically and behave as normal
    nnoremap z= :call EnableSpellCheck()<CR>z=
    " Ensure `]s` and `[s` only enable spell-checking once
    nnoremap ]s :call EnableSpellCheck()<CR>]s
    nnoremap [s :call EnableSpellCheck()<CR>[s
endif

" Words
if filereadable("/usr/share/dict/words")
    set dictionary+=/usr/share/dict/words
endif



" j: remove comment prefix while joining e.g  {#a\n#b} -> #a b vs. #a #b
" o: Insert comment character after adding new empty line below or above
" t: Do not auto-wrap text
" 1: (Obscure) Restricts the effect of autoformat to a single paragraph.
" l: Breaks lines at word boundaries when textwidth is set.
set formatoptions-=t
set formatoptions+=rnjo1l/
set synmaxcol=200 " don't syntax-highlight long lines
set linebreak " Breaks lines at word boundaries rather than in the middle of a word.

" Folding
if has("folding")
    " Turn on folding
    set foldmethod=manual
    " And turn off
    set nofoldenable
endif

" Turn on syntax
if has("syntax")
    syntax enable
endif

filetype plugin on
filetype indent on

" theme/colorscheme
" Set color scheme ( ~/.vim/pack/my/start/utils/colors/ayu.vim )
" colorscheme ayu


" make sure exists in ~/.vim/colors/embark.vim
colorscheme embark

"hi clear
"if exists("syntax_on")
"  syntax reset
"endif

"let colors_name = "ayu"
"
"hi Normal       guifg=#E6E1CF guibg=#0F1419 gui=none ctermfg=230  ctermbg=none cterm=none
"hi NonText      guifg=#A6A1AF guibg=#0F1419 gui=none ctermfg=237  ctermbg=none cterm=none
"hi CursorColumn guifg=NONE    guibg=#191E22 gui=none ctermfg=none ctermbg=234  cterm=none
"hi CursorLine   guifg=NONE    guibg=#191E22 gui=none ctermfg=none ctermbg=234  cterm=none
"hi CursorLineNr guifg=#F29718 guibg=#191E22 gui=none ctermfg=none ctermbg=234  cterm=none
"hi LineNr       guifg=#2D3640 guibg=NONE    gui=none ctermfg=238
"hi ColorColumn  guifg=NONE    guibg=#151A1E gui=none ctermfg=none ctermbg=none cterm=none
"hi Comment      guifg=#5C6773 guibg=NONE    gui=italic    ctermfg=244 ctermbg=none cterm=italic
"hi Constant     guifg=#FFEE99 guibg=NONE    gui=none      ctermfg=221
"hi String       guifg=#B8CC52 guibg=NONE    gui=italic    ctermfg=148 ctermbg=none cterm=italic
"hi Identifier   guifg=#36A3D9 guibg=NONE    gui=none      ctermfg=148
"hi Function     guifg=#FFB454 guibg=NONE    gui=none      ctermfg=214
"hi Statement    guifg=#FF7733 guibg=NONE    gui=italic    ctermfg=208 ctermbg=none cterm=italic
"hi Operator     guifg=#E7C547 guibg=NONE    gui=none      ctermfg=214
"hi PreProc      guifg=#E6B673 guibg=NONE    gui=none      ctermfg=222
"hi Type         guifg=#36A3D8 guibg=NONE    gui=none      ctermfg=45
"hi Structure    guifg=#E6B673 guibg=NONE    gui=none      ctermfg=208
"hi Keyword      guifg=#E6B673 guibg=NONE    gui=italic    ctermfg=45  ctermbg=none cterm=italic
"hi Special      guifg=#E6B673 guibg=NONE    gui=none      ctermfg=244
"hi Undefined    guifg=#36A3D9 guibg=NONE    gui=none      ctermfg=208
"hi Todo         guifg=#F07178 guibg=NONE    gui=italic    ctermfg=211 ctermbg=none cterm=italic
"hi SpellBad     guifg=#F00000 guibg=NONE    gui=undercurl ctermfg=009 ctermbg=none cterm=undercurl
" Matched parent color
"hi MatchParen   guifg=#0F1419 guibg=#B6B1BF gui=italic ctermfg=157  ctermbg=237  cterm=italic
" Completion menu
"hi Pmenu        guifg=#ffffff guibg=#444444 gui=none ctermfg=255  ctermbg=238
"hi PmenuSel     guifg=#000000 guibg=#B8CC52 gui=none ctermfg=0    ctermbg=148
"hi Search       guifg=#0F1419 guibg=#FFEE99 gui=none ctermfg=0  ctermbg=148  cterm=none
"hi StatusLine   guifg=#E6E1CF guibg=#14191F gui=none ctermfg=230  ctermbg=234  cterm=none
"hi StatusLineNC guifg=#2D3640 guibg=#14191F gui=none ctermfg=246  ctermbg=234  cterm=none
"hi VertSplit    guifg=#2D3640 guibg=NONE    gui=none ctermfg=238  ctermbg=none cterm=none
"hi Folded       guifg=#585058 guibg=#151A1E gui=none ctermfg=248  ctermbg=4
"hi FoldColumn   guifg=#585058 guibg=#151A1E gui=none ctermfg=248  ctermbg=4
"hi SignColumn   guifg=#2D3640 guibg=NONE    gui=none ctermfg=248  ctermbg=4
"hi Title        guifg=#787078 guibg=NONE    gui=bold ctermfg=254  ctermbg=none cterm=bold
"hi Visual       guifg=NONE    guibg=#253340 gui=none ctermfg=254  ctermbg=4
"hi SpecialKey   guifg=#A6A1AF guibg=#0F1419 gui=none ctermfg=235  ctermbg=none cterm=none
"hi Directory    guifg=#3E4B59 guibg=NONE    gui=none
"hi TabLineSel   gui=bold ctermfg=148 ctermbg=232 cterm=none
"hi TabLineFill  gui=bold ctermfg=0   ctermbg=232 cterm=none
"hi TabLine      gui=none ctermfg=248 ctermbg=232 cterm=none
"hi DiffAdd      guifg=#87af87 guibg=#0F1419 gui=reverse ctermfg=108  ctermbg=235  cterm=reverse
"hi DiffChange   guifg=#8787af guibg=#0F1419 gui=reverse ctermfg=103  ctermbg=235  cterm=reverse
"hi DiffDelete   guifg=#af5f5f guibg=#0F1419 gui=reverse ctermfg=131  ctermbg=235  cterm=reverse
"hi DiffText     guifg=#ff8700 guibg=#0F1419 gui=reverse ctermfg=208  ctermbg=235  cterm=reverse
"hi QuickFixLineNumber     guifg=#B8CC52 guibg=NONE gui=none   ctermfg=248 ctermbg=none
"hi QuickFixFileName       guifg=#36A3D9 guibg=NONE gui=italic ctermfg=254 ctermbg=none cterm=italic
"hi QuickFixSeparatorBegin guifg=#2D3640 guibg=NONE gui=none   ctermfg=0   ctermbg=none
"hi QuickFixSeparatorEnd   guifg=#2D3640 guibg=NONE gui=none   ctermfg=0   ctermbg=none
"hi User1        guifg=#36A3D9 guibg=#14191F gui=none    ctermfg=38   ctermbg=234  cterm=none
"hi User2        guifg=#FF7733 guibg=#14191F gui=none    ctermfg=202  ctermbg=234  cterm=none
"hi User3        guifg=#FF3333 guibg=NONE    gui=none    ctermfg=196  ctermbg=234  cterm=none
"hi OverLength   guifg=NONE    guibg=NONE    gui=italic  ctermfg=none ctermbg=none cterm=italic
"hi Conceal      guibg=NONE    guifg=NONE    gui=none    ctermbg=NONE ctermfg=NONE cterm=none

" Setup italic in terminal
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"


"Cursor settings:
"  1 -> blinking block
"  2 -> solid block 
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar

"Cursor Mode Settings (use manual termcodes)
let &t_EI.="\e[2 q" "EI = NORMAL mode (ELSE)
let &t_SI.="\e[6 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode

" not working
"set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:ver25,o:ver25

" Setup cursor change on insert mode
"let &t_EI="\033[1 q" " end insert mode, blinking block
"let &t_EI="\033[1 q" " end insert mode, blinking block

" Add color columns to make it visible
"let &colorcolumn="80,".join(range(120,999),",")
"let &colorcolumn=join(range(120,999),",")

" Completion
" <C-x><C-o>
set omnifunc=syntaxcomplete#Complete

" File/path completion
" <C-x><C-f>

" Scrolling
set scrolloff=10
set sidescrolloff=15
set sidescroll=1

"Highlight current line
set cursorline

set timeoutlen=3000

" Search
set incsearch
set hlsearch
set ignorecase " case-insensitive searching
set smartcase  " but become case-sensitive if you type uppercase characters

" Spellline function
function! Spellline()
    if &spell
        return " " . toupper(&spelllang)
    else
        return ""
    endif
endfunction

" Wrapline function
function! Wrapline()
    if &wrap
        return " W"
    else
        return ""
    endif
endfunction

" Trailing spaces warning flag
let g:has_trailing_spaces = ''
function! TrailingSpaces()
    let line = search('\s$', 'nw')
    if line != 0
        let g:has_trailing_spaces = ' !' . line
    else
        let g:has_trailing_spaces = ''
    endif
endfunction

" Git branch name
let g:git_branch_name = ''
function! GitBranchName()
    let command = "cd \"" . expand('%:p:h') . "\" && git symbolic-ref --short HEAD 2>/dev/null"
    " Use last part if branch name separated by '/'
    let branch = system(command . " | awk -F'/' '{printf \"%s\", $NF}'")
    if empty(branch)
        let g:git_branch_name = ''
    else
        let branch = substitute(branch, '\n\+$', '', '')
        let g:git_branch_name = ' ' . branch . ' '
    endif
endfunction

" Git file status
let g:git_file_status = ''
function! GitFileStatus()
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
    " Extract file status flag
    let modifier = system(command . " | grep '" . file . "$' | awk -F' ' '{printf \"%s\", $1}'")
    if empty(modifier)
        let g:git_file_status = ''
    else
        let g:git_file_status = modifier
    endif
endfunction

" Status line
set laststatus=2

set statusline=
set statusline+=%f%m
set statusline+=\ %#User2#
set statusline+=%{g:git_file_status}
set statusline+=\ %=
set statusline+=%#User1#
set statusline+=%{g:git_branch_name}
set statusline+=%*
" set statusline+=%2B
set statusline+=%c/%L\ %p%%
set statusline+=%*
set statusline+=%{Wrapline()}
set statusline+=%{Spellline()}
set statusline+=%#User3#
set statusline+=%{g:has_trailing_spaces}

" Find path
set path=.,**

set pumheight=5 " height of completion options

" Menus, cycle through using <Tab> and <S-Tab>
" Allow <Left> and <Right> to navigate through the completion lists
set wildmenu
" 1st Tab: shows longest match,  2nd tab: completes it, 3rd tab: cycles
set wildmode=longest:full,full
set wildoptions+=fuzzy
set wildchar=<Tab>
set wildcharm=<C-Z>

" =============================================================================
" autocomplete / omnicomplete / tags
" =============================================================================
" Completion options
" longets - completes to longest commont
" menuone - shows menu even with one item
" noinsert - no insert word
" set completeopt=menuone

set completeopt=menuone,noselect,noinsert
set wildignore+=tags,gwt-unitCache/*,*/__pycache__/*,build/*,build.?/*,*/node_modules/*
" Files with these suffixes get a lower priority when matching a wildcard
set suffixes+=.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
      \,.o,.obj,.dll,.class,.pyc,.ipynb,.so,.swp,.zip,.exe,.jar,.gz
" Better `gf`
set suffixesadd=.java,.cs

set title
set titlestring=%{getpid().':'.getcwd()}


" Smart tab for completion
function! Smart_tab()
    let col = virtcol('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-n>"
    endif
endfunction

" -- INSERT --
" Show next completion
inoremap <Tab> <C-r>=Smart_tab()<Enter>
" Show previous completion
inoremap <S-Tab> <C-p>
" Select by pressing <Enter>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" Show completion on Ctrl + Space
" In terminal <C-Space> gets interpreted as <C-@>
inoremap <C-@> <C-n>



" Wrap word with quotes
nnoremap <Leader>" mzviw<Esc>a"<Esc>bi"<Esc>`zl
" Lowercase word
nnoremap <Leader>u mzguaw`z
" Uppercase word
nnoremap <Leader>U mzgUaw`z
" Indent whole file
nnoremap <Leader>ai mzgg=G`z

" Move to the begging of line
nnoremap <silent> <C-a> ^
nnoremap B ^
" Move to the end of line
nnoremap <silent> <C-e> $
nnoremap E $

" Move line/block up/down in Normal & Visual
nnoremap <m-k> :m .-2<Enter>==
nnoremap <m-j> :m .+1<Enter>==
vnoremap <m-k> :m '<-2<Enter>gv=gv
vnoremap <m-j> :m '>+1<Enter>gv=gv

" Execure last command again
nnoremap <Leader>. :!!<Enter>

" Clear search by clearing latest buffer
nnoremap <Esc><Esc> :let @/ = ""<Enter>
nnoremap <Leader>h :let @/ = ""<Enter>


" Map Alt+S (Option+S) to save the file
"nnoremap <M-s> :w<CR>
"inoremap <M-s> <Esc>:w<CR>a

" Make search result in the middle of the screen
nnoremap n nzz
nnoremap N Nzz

nnoremap <S-Tab> <C-w>w

nnoremap <M-s> :update<CR>
inoremap <M-s> <Esc>:update<CR>
nnoremap <C-s> :update<CR>
inoremap <C-s> <Esc>:update<CR>


" Autocommands for Git status and trailing spaces
if has("autocmd")
  " Update trailing space warnings
  autocmd BufEnter,BufWritePost * call TrailingSpaces()

  autocmd BufEnter,BufWritePost,FileWritePost * call GitBranchName() | call GitFileStatus()

  " Unfold all blocks
  autocmd BufEnter * normal zR

  " Quick fix window
  autocmd QuickFixCmdPost * nested cwindow

  " Make session on buffer leave
  autocmd BufWinLeave *.* mkview
  " Load session on buffer enter
  autocmd BufWinEnter *.* silent loadview

  " Jump to the last line when reopening file
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
              \| exe "normal! g'\"" | endif

endif



" At start of vimrc/init.vim:
if $SSH_CLIENT != "" || $SSH_TTY != ""
    " PUT THE ENTIRE OSCYANK CODE HERE - everything from:
    let g:oscyank_silent     = 0  " disable message on successful copy
    let g:oscyank_trim       = 0  " trim surrounding whitespaces before copy
" -------------------- INIT --------------------------------
  if exists('g:loaded_oscyank')
    finish
  endif
  let g:loaded_oscyank = 1
  
  " -------------------- VARIABLES ---------------------------
  let s:commands = {
    \ 'operator': {'block': '`[\<C-v>`]y', 'char': '`[v`]y', 'line': "'[V']y"},
    \ 'visual': {'': 'gvy', 'V': 'gvy', 'v': 'gvy', '': 'gvy'}}
  let s:b64_table = [
    \ 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
    \ 'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
    \ 'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
    \ 'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/']
  
  " -------------------- OPTIONS ---------------------------
  function s:options_max_length()
    return get(g:, 'oscyank_max_length', 0)
  endfunction
  
  function s:options_silent()
    return get(g:, 'oscyank_silent', 0)
  endfunction
  
  function s:options_trim()
    return get(g:, 'oscyank_trim', 0)
  endfunction
  
  function s:options_osc52()
    return get(g:, 'oscyank_osc52', "\x1b]52;c;%s\x07")
  endfunction
  
  " -------------------- UTILS -------------------------------
  function s:echo(text, hl)
    echohl a:hl
    echo printf('[oscyank] %s', a:text)
    echohl None
  endfunction
  
  function s:encode_b64(str, size)
    let bytes = map(range(len(a:str)), 'char2nr(a:str[v:val])')
    let b64 = []
  
    for i in range(0, len(bytes) - 1, 3)
      let n = bytes[i] * 0x10000
            \ + get(bytes, i + 1, 0) * 0x100
            \ + get(bytes, i + 2, 0)
      call add(b64, s:b64_table[n / 0x40000])
      call add(b64, s:b64_table[n / 0x1000 % 0x40])
      call add(b64, s:b64_table[n / 0x40 % 0x40])
      call add(b64, s:b64_table[n % 0x40])
    endfor
  
    if len(bytes) % 3 == 1
      let b64[-1] = '='
      let b64[-2] = '='
    endif
  
    if len(bytes) % 3 == 2
      let b64[-1] = '='
    endif
  
    let b64 = join(b64, '')
    if a:size <= 0
      return b64
    endif
  
    let chunked = ''
    while strlen(b64) > 0
      let chunked .= strpart(b64, 0, a:size) . "\n"
      let b64 = strpart(b64, a:size)
    endwhile
  
    return chunked
  endfunction
  
  function s:get_text(mode, type)
    " Save user settings
    let l:clipboard = &clipboard
    let l:selection = &selection
    let l:register = getreg('"')
    let l:visual_marks = [getpos("'<"), getpos("'>")]
  
    " Retrieve text
    set clipboard=
    set selection=inclusive
    silent execute printf('keepjumps normal! %s', s:commands[a:mode][a:type])
    let l:text = getreg('"')
  
    " Restore user settings
    let &clipboard = l:clipboard
    let &selection = l:selection
    call setreg('"', l:register)
    call setpos("'<", l:visual_marks[0])
    call setpos("'>", l:visual_marks[1])
  
    return l:text
  endfunction
  
  function s:trim_text(text)
    let l:text = a:text
    let l:indent = matchstrpos(l:text, '^\s\+')
  
    " Remove common indent from all lines
    if l:indent[1] >= 0
      let l:pattern = printf('\n%s', repeat('\s', l:indent[2] - l:indent[1]))
      let l:text = substitute(l:text, l:pattern, '\n', 'g')
    endif
  
    return trim(l:text)
  endfunction
  
  function s:write(osc52)
    if filewritable('/dev/fd/2') == 1
      let l:success = writefile([a:osc52], '/dev/fd/2', 'b') == 0
    elseif has('nvim')
      let l:success = chansend(v:stderr, a:osc52) > 0
    else
      exec("silent! !echo " . shellescape(a:osc52))
      redraw!
      let l:success = 1
    endif
    return l:success
  endfunction
  
  " -------------------- PUBLIC ------------------------------
  function! OSCYank(text) abort
    let l:text = s:options_trim() ? s:trim_text(a:text) : a:text
  
    if s:options_max_length() > 0 && strlen(l:text) > s:options_max_length()
      call s:echo(printf('Selection is too big: length is %d, limit is %d', strlen(l:text), s:options_max_length()), 'WarningMsg')
      return
    endif
  
    let l:text_b64 = s:encode_b64(l:text, 0)
    let l:osc52 = printf(s:options_osc52(), l:text_b64)
    let l:success = s:write(l:osc52)
  
    if !l:success
      call s:echo('Failed to copy selection', 'ErrorMsg')
    endif
  
    return l:success
  endfunction
  
  function! OSCYankOperatorCallback(type) abort
    let l:text = s:get_text('operator', a:type)
    return OSCYank(l:text)
  endfunction
  
  function! OSCYankOperator() abort
    set operatorfunc=OSCYankOperatorCallback
    return 'g@'
  endfunction
  
  function! OSCYankVisual() abort
    let l:text = s:get_text('visual', visualmode())
    return OSCYank(l:text)
  endfunction
  
  function! OSCYankRegister(register) abort
    let l:text = getreg(a:register)
    return OSCYank(l:text)
  endfunction
  
  
  " -------------------- COMMANDS ----------------------------
  command! -nargs=1 OSCYank call OSCYank('<args>')
  command! -range OSCYankVisual call OSCYankVisual()
  command! -register OSCYankRegister call OSCYankRegister('<reg>')
  
  nnoremap <expr> <Plug>OSCYankOperator OSCYankOperator()
  vnoremap <Plug>OSCYankVisual :OSCYankVisual<CR>
  
  let s:VimOSCYankPostRegisters = ['', '+', '*']
  function! s:VimOSCYankPostCallback(event)
    if a:event.operator == 'y' && index(s:VimOSCYankPostRegisters, a:event.regname) != -1
      call OSCYankRegister(a:event.regname)
    endif
  endfunction
  
  augroup VimOSCYankPost
    autocmd!
    autocmd TextYankPost * call s:VimOSCYankPostCallback(v:event)
  augroup END

  " Make d and D work with OSCYank
  nnoremap <expr> D 'D' . OSCYankOperator()
else
    " Local system clipboard settings only
    if has('macunix')
        " set clipboard=unnamed
        set clipboard=unnamed,unnamedplus  " Use both * and + registers
    elseif has('unix')
        set clipboard=unnamedplus

    endif
endif


" smart delete
nnoremap <expr> dd  getline('.') =~# '^\\s*$' ? '"_dd' : 'dd'
nnoremap V vg_


" Format file <leader> f
nnoremap <leader>f m`gg=G``

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


" For normal mode - toggle current line
nnoremap <C-/> :call ToggleComment()<CR>
nnoremap <D-/> :call ToggleComment()<CR>

" For visual mode - toggle selected lines
xnoremap <C-/> :call ToggleComment()<CR>

nnoremap <expr> <Alt-k> line('.') > 1 ? ':move .-2<CR>==':''
inoremap <expr> <Alt-k> line('.') > 1 ? ':move .-2<CR>==':''
inoremap <expr> <Alt-j> line('.') < line('$') ? ':move .+1<CR>==':''
nnoremap <expr> <Alt-j> line('.') < line('$') ? ':move .+1<CR>==':''
"EOF
