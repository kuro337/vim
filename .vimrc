scriptencoding utf-8

set encoding=utf-8

let g:did_install_default_menus = 1  " avoid stupid menu.vim (saves ~100ms)
let mapleader=" "       " The <leader> key
set backspace=2           " Makes backspace behave like you'd expect
set hidden                " Allow buffers to be backgrounded without being saved
set laststatus=2          " Always show the status bar
set list                  " Show invisible characters
set mouse=a               " Enable Mouse Support All modes
set ruler                 " Show the line number and column in the status bar
set number
set termguicolors
set t_Co=256              " Use 256 colors
set scrolloff=999         " Keep the cursor centered in the screen
set sidescroll=1
set sidescrolloff=15
set showmatch             " Highlight matching braces
set matchtime=2           " Cursor Shifts for 2ms after a Matching Pair Entered
set showmode              " Show the current mode on the open buffer
set splitbelow            " Splits show up below by default
set splitright            " Splits go to the right by default
set nomodeline            " Disable mode lines for security reasons. e.g Prevents code like # vim: !rm x-rf
set cursorline            " Highlight current line
set cursorcolumn          " Highlight current column
set visualbell            " Use a visual bell to notify us
set ttimeoutlen=10        " Timeout for key code delays
set timeoutlen=500        " Timeout for mapping delays
set belloff=all
set autoread              " Reload files that have not been modified
set nowrap
set textwidth=0           " (disable w/ 0) After 120 Columns, newline automatically inserted"
set nocompatible          " Turn off Vi-compatible mode to enable modern features
set cpoptions-=_          " Removes _ from compat option to retain the undo history
set viewoptions-=options  " Do not save buflocal settings for Views
set nostartofline         " Prevents moving the cursor to the start of the line when switching buffers or jumping.
set synmaxcol=200         " don't syntax-highlight long lines
set linebreak             " Breaks lines at word boundaries rather than in the middle of a word.
set sessionoptions=curdir,folds,help,options,tabpages,winsize

"set colorcolumn=80        " Highlight 80 character limit
" set formatoptions-=t
" set formatoptions+=rnjol/

set listchars=tab:\|\ ,eol:¬,trail:⋅ "Set the characters for the invisibles

" Tab settings
set expandtab     " Expand tabs to Spaces
set tabstop=4     " Tabs width in spaces
set softtabstop=4 " Soft tab width in spaces
set shiftwidth=4  " Amount of spaces when shifting
set autoindent
set smartindent
set smarttab

" Search settings
set hlsearch   " Highlight results
set ignorecase " Ignore casing of searches
set incsearch  " Start showing results as you type
set smartcase  " Be smart about case sensitivity when searching

" Cursor settings: 1:blink_block | 2:solid_block | 3:blin_underscore | 4:solid_underscore | 5:blink_vertical | 6:solid_vertical
let &t_EI.="\e[2 q" "EI = NORMAL mode  -> Solid Block
let &t_SI.="\e[6 q" "SI = INSERT mode  -> Solid Vertical
let &t_SR.="\e[4 q" "SR = REPLACE mode -> Solid Underscore

let &t_TI = ""
let &t_TE = ""

" Folding
if has("folding")
  set nofoldenable         " Unfold all
  set foldmethod=manual    " Manual folding only
endif

" Find path
set path=.,**
set pumheight=5 " height of completion options

" Tab completion settings
set wildmenu                  " Allow <Left> and <Right> to navigate through the completion lists
set wildmode=list:longest     " Wildcard matches show a list, matching the longest first
set wildchar=<Tab>
set wildcharm=<C-Z>
set wildignore+=.git,.hg,.svn " Ignore version control repos
set wildignore+=*.6           " Ignore Go compiled files
set wildignore+=*.pyc         " Ignore Python compiled files
set wildignore+=*.rbc         " Ignore Rubinius compiled files
set wildignore+=*.swp         " Ignore vim backups
set wildignore+=tags,gwt-unitCache/*,*/__pycache__/*,build/*,build.?/*,*/node_modules/*
if has("nvim")
  set wildoptions+=fuzzy
endif

" Completion options
" longets - completes to longest commont
" menuone - shows menu even with one item
" noinsert - no insert word
" set completeopt=menuone
set completeopt=menuone,noselect,noinsert
" Files with these suffixes get a lower priority when matching a wildcard
set suffixes+=.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.o,.obj,.dll,.class,.pyc,.ipynb,.so,.swp,.zip,.exe,.jar,.gz
set suffixesadd=.java,.cs

" set titlestring=%{expand('%')}

set title
let &titleold = $__wtitle

" menuone, noselect, noinsert
" set completopt

if !has("nvim")
  set guioptions=cegmt
endif

" Load Yanking Functionality from ~/.vim/lib/func.vim
let g:vim_home = $HOME . '/.vim'

fun! s:Source(p)
  if !empty(glob(a:p))
    exe 'source '.a:p
    return 1
  endif
  echoerr "Failed to source " . a:p
endfun

if !s:Source(g:vim_home."/lib/func.vim") || !s:Source(g:vim_home."/lib/grep.vim")
  echoerr "Failed to source vim utils"
  finish
endif

func! s:VimDir(p)
  if !isdirectory(a:p) |  call mkdir(a:p,'p',0700) | endif
  return a:p
endfunc


" Backup settings
let s:vtmp = $HOME . '/.cache/vim'
exe "set directory=". s:VimDir(s:vtmp .'/swap')
exe "set backupdir=". s:VimDir(s:vtmp."/backup")
exe "set viewdir="  . s:VimDir(s:vtmp."/view")
exe "set undodir="  . s:VimDir(s:vtmp."/undo")

set exrc        " Allow .nvimrc / .exrc files in cwd
set noswapfile  " Turn off swap files
set backup      " Create backup before writing and keep backup files (will be overwritten on future backups)
set undofile    " Persistent undo across sessions
set writebackup

if has('clipboard')
  set clipboard=unnamed
  if has('unnamedplus')
    set clipboard+=unnamed
  endif
endif
filetype plugin on
filetype indent on
" theme/colorscheme
if PathValid(g:vim_home . '/colors/moonfly.vim') |  colorscheme moonfly  | endif
" Turn on syntax
if has("syntax")
  syntax enable
  syntax on
endif
if !has("gui_running")
  let &t_ut=''
endif
" Completion <C-x><C-o>
set omnifunc=syntaxcomplete#Complete
if exists('g:mergetool_mode')
  let g:gmode = 'mergetool'
  set wrap
  set linebreak
  set nolist
  set nonumber
  set signcolumn=no
  " set diffopt+=iwhite     " Disable WhiteSpace
  " set diffopt+=context:0  " Use Zero Lines of Context (show only conflicts)
  "
  " Quit/abandon <C-d>, <C-q>
  " Force Quit
  nnoremap <C-d> :qa!<CR>
  nnoremap <C-q> :cquit<CR>
  nnoremap <C-p> :cquit<CR>

  " Save & exit <leader>s
  nnoremap <leader>s :wqa!<CR>

  " :diffg LO LOCAL   | Leader 1
  " :diffg RE REMOTE  | Leader 2
  " :diffg BA BASE    | Leader b
  nnoremap <leader>1 :diffget LO<CR>
  nnoremap <leader>2 :diffget RE<CR>
  nnoremap <leader>b :diffget BA<CR>

  finish
endif

"----------------------------------------------------------------------
" Key Mappings
"----------------------------------------------------------------------

" Update Alt for Legacy Terminals
" <Nul> is <C-Space>
" for xterm/legacy terms, manually map Alt/Meta keycodes
func! s:altmap(keys,mode)
  for k in split(keys,'\zs')
    exec "set <M-".k.">=\e".k
    exec mode." \e".k."<M-".k">"
  endfor
endfunc



if has('mac')                            
  nnoremap <expr> <M-j> line('.') < line('$') ? ':move .+1<CR>==':''
  nnoremap <expr> <M-k> line('.') > 1 ? ':move .-2<CR>==':''
else
  call s:altmap('hjkl0bd','cnoremap')
  call s:altmap('hjklisv','inoremap')
  call s:altmap(',.','nnoremap')


  nnoremap <expr> <M-j> line('.') < line('$') ? ':move .+1<CR>==':''
  nnoremap <expr> <M-k> line('.') > 1 ? ':move .-2<CR>==':''


  " Updates Raw Terminal Codes for Legacy Terminals
  "let &t_TI = ""
  "let &t_TE = ""

  endif 


" Make j/k visual down and up instead of whole lines. This makes word
" wrapping a lot more pleasent.
map j gj
map k gk

" cd to the directory containing the file in the buffer. Both the local
" and global flavors.
nmap <leader>cd :cd %:h<CR>
nmap <leader>lcd :lcd %:h<CR>


" Shortcut to yanking to the system clipboard
" map <leader>y "+y
" map <leader>p "+p
xnoremap Y "+y

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

" Move line/block up/down in Normal, Insert, Visual
vnoremap <A-k> :m '<-2<Enter>gv=gv
vnoremap <A-j> :m '>+1<Enter>gv=gv
nnoremap <expr> <A-j> line('.') < line('$') ? ':move .+1<CR>==':''
nnoremap <expr> <A-k> line('.') > 1 ? ':move .-2<CR>==':''
inoremap <expr> <A-j> line('.') < line('$') ? '<Esc>:move .+1<CR>==i':''
inoremap <expr> <A-k> line('.') > 1 ? '<Esc>:move .-2<CR>==i':''

" up/down in cmd line
cnoremap  <M-h> <Left>
cnoremap  <M-j> <Down>
cnoremap  <M-k> <Up>
cnoremap  <M-l> <Right>
cnoremap  <M-0> <Home>
cnoremap  <M-b> <Home>


" Execure last command again
nnoremap <Leader>. :!!<Enter>

" Clear search by clearing latest buffer
nnoremap <Esc><Esc> :let @/ = ""<cr>
nnoremap <Leader>h :let @/ = ""<cr>

" Get rid of search highlights
noremap <silent><leader>/ :nohlsearch<cr>

" Make search result in the middle of the screen
nnoremap n nzz
nnoremap N Nzz
" Format file <leader> f
nnoremap <leader>fm m`gg=G``
nnoremap <Leader>k <C-W>w
nnoremap <S-Tab> <C-w>w

nnoremap <leader>v <C-v>

" Saving :update - Write File only if Modified
nnoremap <A-s> :update<CR>
inoremap <A-s> <Esc>:update<CR>
nnoremap <C-s> :update<CR>
inoremap <C-s> <Esc>:update<CR>


cnoremap <M-%> <c-r>=fnamemodify(@%, ':t')<cr>
cnoremap <M-5> <c-r>=fnamemodify(@%, ':t')<cr>
noremap! <m-/> <c-r>=expand('%:p:h', 1)<cr>

" cnoremap <expr> <BS> (getcmdtype() =~ '[/?]' && getcmdline() == '') ? '\v^(()@!.)*$<Left><Left><Left><Left><Left><Left><Left>' : '<BS>'
" Visual Mode Keymaps
" xnoremap p "_dp
xnoremap <expr> p 'pgv"' . v:register . 'y'

" Repeat last command for each line of a visual selection.
xnoremap . :normal .<CR>

xnoremap <Leader>db :g/^$/d<CR>

" Show next completion
inoremap <Tab> <C-r>=Smart_tab()<Enter>

" Show previous completion
inoremap <S-Tab> <C-p>
" Select by pressing <Enter>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" smart delete
nnoremap <expr> dd  getline('.') =~# '^\\s*$' ? '"_dd' : 'dd'
nnoremap V vg_

" Expand in command mode to the path of the currently open file
cnoremap %% <C-R>=expand('%:h:p').'/'<CR>


" Buffer management
nnoremap <leader>d   :bd<cr>

"   Tabs
" nnoremap <leader>t :tabnew<CR>
nnoremap <leader>c :tabclose<CR>
nnoremap <nowait> <leader>t :tabnext<CR>
nnoremap <A-.> :tabnext<CR>
nnoremap <A-,> :tabprevious<CR>
nnoremap <C-d> :bd<CR>

" Switch wins
nnoremap <C-1> <C-^>

" Cycle Windows
nnoremap <nowait> <Leader>n <C-w>w

" nnoremap <C-d> :qa!<CR>
command! Q execute "normal! :qa!\<CR>"

" Alt i to exit Insert Mode
inoremap <A-i> <Esc><Esc>


"----------------------------------------------------------------------
" Netrw Explorer
" loaded_netrwPlugin = 0   | Disable netrw
" netrw_banner       = 0   | No Banner
" netrw_keepdir      = 0   | Update cwd for tree to Buffer cwd
" netrw_winsize      = 20  | Initial Explorer Size
" netrw_browse_split = 3   | Default to new tabs for buffers
"----------------------------------------------------------------------
let g:loaded_netrw       = 0  " Disable netrw autoload
let g:loaded_netrwPlugin = 0  " Disable netrw

" NOTE: ftplugin/netrw.vim also defines buffer local ToggleTree
" Toggle the Tree from bufnr
func! ToggleTree()


  if ! exists('g:lzinit_netrw')
    call tree#init#Netrw()
  endif

  " if tree doesn't exists, create it for the 1st time
  if !exists('g:tree_bufnr')
    call Log("treebuf does not exist")
    let currtitle = &titlestring
    exe 'keepalt rightbelow vertical 20split | Explore '
    let g:tree_bufnr = bufnr('%')

    call Log("Initialized Tree bufnr: " . g:tree_bufnr)
    let &titlestring = currtitle
    return
  endif

  let l:found_net = 0
  for w in range(1, winnr('$'))
    let buf = winbufnr(w)
    if getbufvar(buf,'&filetype') ==# 'netrw'
      call Log('netrw alr open in win ' . w)
      let l:found_net = 1
      execute w . 'wincmd w'
      return
    endif
  endfor

  call Log('no netrw open, opening new one')
  execute 'keepalt rightbelow vertical 20split | Explore'

endfunc

" leader + n : Cycle Windows
" leader + t : Cycle Tabs
nnoremap <Leader>e :call ToggleTree()<CR>
nnoremap <Leader>q :wq<CR>

"----------------------------------------------------------------------
" Statusline
"----------------------------------------------------------------------
" %f   : Filename
" %m   : Modified
" %r   : Readonly
" %h   : Help Flag
" %w   : Preview Win Flag
" %l   : Line Number
" %L   : Total Lines
" %c   : Column Number
" %p%% : Percentage through File
function! KLine() abort
  let left = '  ' . printf('%s  %s%s %d%%%% %d/%d C%d %%#StatusLineVisual#%s%%*',
        \ fnamemodify(bufname('%'), ':~:.'),
        \ (&modified ? ' [M]' : ''),
        \ (&readonly ? ' [R]' : ''),
        \ line('.') * 100 / max([1, line('$')]),
        \ line('.'), line('$'),
        \ col('.'),
        \ mode()=~# 'v' ? abs(virtcol("v") - virtcol(".")) + 1 : '')

  let mid = '                 '

  let right = printf('%d | %s |', bufnr('%'),(&filetype == '' ? 'none' : &filetype))
  return left . '%=' . mid . '%=' . right
endfunction

set statusline=%!KLine()

"----------------------------------------------------------------------
" Autocommands
"----------------------------------------------------------------------
if has("autocmd")

  " Don't fold anything.
  autocmd BufWinEnter * set foldlevel=999999

  func! <SID>OnEnterBuf()
    " Unfold all blocks
    execute('normal zR')

    " Prevent netrw from setting title
    if &filetype != "netrw"
      let &titlestring = expand('%:t')
    endif
  endfunc


  autocmd BufEnter * call <SID>OnEnterBuf()

  " Quick fix window
  autocmd QuickFixCmdPost * nested cwindow

  " Make session on buffer leave
  autocmd BufWinLeave *.* mkview
  " Load session on buffer enter
  autocmd BufWinEnter *.* silent loadview

  " Jump to the last line when reopening file
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif

  " preserve settings and only change if not set
  " autocmd FileType * autocmd CursorMoved * ++once if !&expandtab | setlocal listchars+=tab:\ \  | endif

autocmd FileType help
      \ nnoremap <buffer> q :quit<CR> |
      \ nnoremap <buffer> = :resize +10<CR> |
      \ nnoremap <buffer> - :resize -10<CR> |
      \ wincmd J

autocmd FileType man nnoremap <buffer> q :quit<CR>


" au VimEnter *         sil call s:VimEnter(expand("<amatch>"))

endif

" Source last
" execute 'source ' . s:vimabbrs

if  !s:Source(g:vim_home . "/lib/abbr.vim")
  echoerr "Failed to source vim abbrs"
endif


" for GNOME
" let c='a'
" while c <= 'z'
" exec "set <A-" . c . ">=\e" . c
" exec "imap \e" . c . " <A-" . c . ">"
" let c = nr2char(1+char2nr(c))
" endw


"EOF

