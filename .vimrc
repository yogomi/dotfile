" vim:fileencoding=utf-8

set nocompatible
filetype plugin on

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

augroup MyAutoCmd
    autocmd!
augroup END

let ostype = system('uname')

call neobundle#rc(expand('~/.vim/bundle/'))

set clipboard+=unnamed

 " Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

 " Recommended to install
 " After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc', {
    \ 'build' : {
    \   'windows' : 'echo "X<"',
    \   'cygwin' : 'make -f make_cygwin.mak',
    \   'mac' : 'make -f make_mac.mak',
    \   'unix' : 'make -f make_unix.mak',
    \ },
    \}

function! s:meet_neocomplete_requirements()
  return has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
endfunction

" My Bundles here:
"
" Note: You don't set neobundle setting in .gvimrc!
" Original repos on github
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'rstacruz/sparkup', {'rtp': 'vim/'}
" NeoBundle 'Rykka/riv.vim'

""" for html and js
NeoBundle 'mattn/emmet-vim'
NeoBundle 'othree/html5.vim'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'hail2u/vim-css3-syntax'
"""

if s:meet_neocomplete_requirements()
  NeoBundle 'Shougo/neocomplete.vim'
  NeoBundleFetch 'Shougo/neocomplcache.vim'
else
  NeoBundleFetch 'Shougo/neocomplete.vim'
  NeoBundle 'Shougo/neocomplcache.vim'
endif

NeoBundle 'yogomi/Flake8-vim', 'preparationForPython2.6'
let g:PyFlakeOnQrite = 1
let g:PyFlakeCheckers = 'pep8,mccabe,pyflakes'
let g:PyFlakeDefaultComplexity=10
let g:PyFlakeCWindow = 9
let g:PyFlakeSigns = 1
let g:PyFlakeMaxLineLength = 100
let g:PyFlakeRangeCommand = 'Q'

NeoBundle 'thinca/vim-quickrun'

NeoBundle 'altercation/vim-colors-solarized'

NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/vimfiler.vim'
" vim-scripts repos
NeoBundle 'L9'
NeoBundle 'FuzzyFinder'
NeoBundle 'rails.vim'
" Non github repos
NeoBundle 'git://git.wincent.com/command-t.git'
" Non git repos
" NeoBundle 'http://svn.macports.org/repository/macports/contrib/mpvim/'
NeoBundle 'https://bitbucket.org/ns9tks/vim-fuzzyfinder'
NeoBundle 'funorpain/vim-cpplint'

" NeoBundleLazy 'hachibeeDI/python_hl_lvar.vim', {
" \   'autoload' : {
" \     'filetypes' : ['python'],
" \   },
" \ }
" let g:enable_python_hl_lvar = 1
" default is 'guifg=palegreen3 gui=NONE ctermfg=114 cterm=NONE'
" let g:python_hl_lvar_highlight_color = 'guifg=palegreen3 gui=NONE ctermfg=186 cterm=NONE'

" autocmd BufWinEnter  *.py PyHlLVar
" autocmd BufWinLeave  *.py PyHlLVar
" autocmd WinEnter     *.py PyHlLVar
" autocmd BufWritePost *.py PyHlLVar
" autocmd WinLeave     *.py PyHlLVar
" autocmd TabEnter     *.py PyHlLVar
" autocmd TabLeave     *.py PyHlLVar

" ...

"
" Brief help
" :NeoBundleList          - list configured bundles
" :NeoBundleInstall(!)    - install(update) bundles
" :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles

" Installation check.
NeoBundleCheck

set pastetoggle=<F10>

""" key bind
nnoremap <Space>. :<C-u>edit $MYVIMRC<Enter>
nnoremap <Space>s. :<C-u>source $MYVIMRC<Enter>

" disable arrow keys
map <Up> <nop>
map <Down> <nop>
map <Left> <nop>
map <Right> <nop>
imap <Up> <nop>
imap <Down> <nop>
imap <Left> <nop>
imap <Right> <nop>

" ---- insert mode ---- {{{
"emacs like key-bind in insert mode
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-h> <Backspace>
inoremap <C-d> <Del>

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-h> <Backspace>
cnoremap <C-d> <Del>

"" ement key-bind
nmap ,, <C-Y>,

""" view
syntax on

set background=dark
"colorscheme solarized
let g:solarized_termcolors=256
"let g:solarized_termtrans = 1
"let g:solarized_italic = 0

if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \  exe "normal! g'\"" |
  \  endif
endif

""" cpplint
autocmd BufWritePost *.h,*.cpp,*.cc call Cpplint()
"""

""" unite
let g:unite_winwidth = 40
nnoremap <C-u> :Unite -vertical file buffer<CR>
nnoremap <C-u><C-o> :Unite -vertical outline<CR>
"""

""" vimfiler
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
"""

nnoremap ; :

if s:meet_neocomplete_requirements()
  """ neocomplete
  " 補完ウィンドウの設定
  set completeopt=menuone

  " 起動時に有効化
  let g:neocomplete#enable_at_startup = 1

  " 大文字が入力されるまで大文字小文字の区別を無視する
  let g:neocomplete#enable_smart_case = 1

  " ポップアップメニューで表示される候補の数
  let g:neocomplete#max_list = 20

  " シンタックスをキャッシュするときの最小文字長
  let g:neocomplete#sources#syntax#min_keyward_length = 3

  " ディクショナリ定義
  let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ 'php' : $HOME . '/.vim/dict/php.dict',
      \ 'ctp' : $HOME . '/.vim/dict/php.dict'
      \ }

  if !exists('g:neocomplete#keyword_patterns')
          let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  " 前回行われた補完をキャンセルします
  inoremap <expr><C-g> neocomplete#undo_completion()

  " 補完候補のなかから、共通する部分を補完します
  inoremap <expr><C-l> neocomplete#complete_common_string()

  " 改行で補完ウィンドウを閉じる
  inoremap <expr><CR> neocomplete#smart_close_popup() . "\<CR>"

  "tabで補完候補の選択を行う
  inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

  " <C-h>や<BS>を押したときに確実にポップアップを削除します
  inoremap <expr><C-h> neocomplete#smart_close_popup().”\<C-h>”

  " 現在選択している候補を確定します
  inoremap <expr><C-y> neocomplete#close_popup()

  " 現在選択している候補をキャンセルし、ポップアップを閉じます
  inoremap <expr><C-e> neocomplete#cancel_popup()
else
  """ neocomplcache
  " 補完ウィンドウの設定
  set completeopt=menuone

  " 起動時に有効化
  let g:neocomplcache_enable_at_startup = 1

  " 大文字が入力されるまで大文字小文字の区別を無視する
  let g:neocomplcache_enable_smart_case = 1

  let g:neocomplcache_enable_camel_case_completion  =  1

  " ポップアップメニューで表示される候補の数
  let g:neocomplcache_max_list = 20

  " シンタックスをキャッシュするときの最小文字長
  let g:neocomplcache_min_syntax_length = 3

  " ディクショナリ定義
  let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default' : '',
      \ 'php' : $HOME . '/.vim/dict/php.dict',
      \ 'ctp' : $HOME . '/.vim/dict/php.dict'
      \ }

  if !exists('g:neocomplcache_keyword_patterns')
          let g:neocomplcache_keyword_patterns = {}
  endif
  let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

  " 前回行われた補完をキャンセルします
  inoremap <expr><C-g> neocomplcache#undo_completion()

  " 補完候補のなかから、共通する部分を補完します
  inoremap <expr><C-l> neocomplcache#complete_common_string()

  " 改行で補完ウィンドウを閉じる
  inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"

  "tabで補完候補の選択を行う
  inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

  " <C-h>や<BS>を押したときに確実にポップアップを削除します
  inoremap <expr><C-h> neocomplcache#smart_close_popup().”\<C-h>”

  " 現在選択している候補を確定します
  inoremap <expr><C-y> neocomplcache#close_popup()

  " 現在選択している候補をキャンセルし、ポップアップを閉じます
  inoremap <expr><C-e> neocomplcache#cancel_popup()
endif

set t_Co=256
set fileformats=unix,dos
set incsearch
set ignorecase
" 大文字小文字の両方が含まれる場合のみ大文字小文字を区別
set smartcase
set shiftround
set softtabstop=2
set tabstop=8
set shiftwidth=2
set backspace=indent,eol,start
set expandtab
set autoindent
set hlsearch
set number
" タブと行末の空白を可視化
set list
set listchars=tab:>-,trail:~

set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2

nmap <Esc><Esc> :nohlsearch<CR><Esc>
set cursorline
filetype plugin indent on     " Required!
if has('path_extra')
    set tags& tags+=.tags,tags
endif
set showtabline=2
set laststatus=2
set ambiwidth=double
set noswapfile

""" highlight
highlight Title term=bold ctermfg=121 gui=bold guifg=#60ff60
"""

""" quickrun
if !exists("g:quickrun_config")
  let g:quickrun_config={}
endif
let g:quickrun_config["_"] = {
  \ "outputter/buffer/split" : ":rightbelow 8sp"
  \ }
"""

""" cache
set backupdir=~/.vimcache/bak
set viminfo& viminfo+=n~/.vimcache/viminfo
if v:version >= 703
    set undodir=~/.vimcache/undo
    set undofile

  " for snippet_complete marker
  " conceal in insert (i), normal (n) and visual (v) modes
  set conceallevel=2 concealcursor=inv
  set colorcolumn=79
endif

"""

function! GetCursorSyntaxGroup()
    echo "hi<" .synIDattr(synID(line("."), col("."), 1), "name") . '> trans<'
        \   . synIDattr(synID(line("."), col("."), 0), "name") . '> lo<'
        \   . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name") . ">"
endfunction

map <Leader>s :call GetCursorSyntaxGroup()<CR>

source ${HOME}/.vim/binary.vim
