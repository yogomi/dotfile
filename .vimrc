" vim:fileencoding=utf-8

set nocompatible
filetype plugin on

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

augroup MyAutoCmd
    autocmd!
augroup END

if has("win64")
  let ostype = 'windows'
else
  let ostype = system('uname')
endif

call neobundle#begin(expand('~/.vim/bundle/'))

set clipboard+=unnamed

 " Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

if !has("win64")
  " Recommended to install
  " After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
  NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \   'windows' : 'nmake -f make_msvc.mak nodebug=1',
      \   'cygwin' : 'make -f make_cygwin.mak',
      \   'mac' : 'make -f make_mac.mak',
      \   'unix' : 'make -f make_unix.mak',
      \ },
      \}
endif

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
let g:user_emmet_settings = {
      \  'javascript.jsx' : {
      \      'extends': 'jsx',
      \      'quote_char': "'",
      \  },
      \}

NeoBundle 'hail2u/vim-css3-syntax'

""" syntastic lint系のため
NeoBundle 'scrooloose/syntastic.git'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn
"""

NeoBundleLazy 'Shougo/neocomplete.vim', {
\   'autoload' : {
\     'insert' : 1,
\ },
\   'depends' : 'Shougo/context_filetype.vim',
\   'disabled' : !(has('lua') || has('luajit')),
\   'vim_version' : '8.0.69'
\ }
NeoBundleLazy 'Shougo/neosnippet', {
\ 'autoload' : {
\   'mappings' : ['<Plug>(neosnippet_'],
\   'commands' : ['NeoSnippetClearMarkers', ],
\   'function_prefix' : 'neosnippet',
\ }}
NeoBundleLazy 'Shougo/neosnippet-snippets', {
\ 'autoload' : {
\   'insert' : 1,
\ },
\ }

NeoBundle 'thinca/vim-quickrun'

NeoBundle 'altercation/vim-colors-solarized'

NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/vimfiler.vim'
" vim-scripts repos
NeoBundle 'L9'
NeoBundle 'rails.vim'
" Non github repos
NeoBundle 'vim-scripts/command-t'
" Non git repos
" NeoBundle 'http://svn.macports.org/repository/macports/contrib/mpvim/'
NeoBundle 'yogomi/vim-cpplint'

NeoBundle "tyru/caw.vim.git"

NeoBundle 'myhere/vim-nodejs-complete'

NeoBundle 'embear/vim-localvimrc'

let g:localvimrc_persistent = 1

runtime! include/*.vim

" file encoding
set encoding=utf-8
set fileencodings=utf-8,sjis,euc-jp
set fileformats=unix,dos,mac


" Installation check.
NeoBundleCheck
call neobundle#end()

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
let g:cpplint_cmd_options="--linelength=100 --filter=-readability/streams,-build/c++11"
"""

""" JavaScript
autocmd FileType javascript setlocal omnifunc=nodejscomplete#CompleteJS
if !exists('g:neocomplcache_omni_functions')
  let g:neocomplcache_omni_functions = {}
endif
let g:neocomplcache_omni_functions.javascript = 'nodejscomplete#CompleteJS'

let g:node_usejscomplete = 1
""" JavaScript end

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

if !has("win64")
  " <C-h>や<BS>を押したときに確実にポップアップを削除します
  inoremap <expr><C-h> neocomplete#smart_close_popup().”\<C-h>”
endif

" 現在選択している候補を確定します
inoremap <expr><C-y> neocomplete#close_popup()

" 現在選択している候補をキャンセルし、ポップアップを閉じます
inoremap <expr><C-e> neocomplete#cancel_popup()

if !has("win64")
  set t_Co=256
endif
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

filetype plugin indent on     " Required!
if has('path_extra')
    set tags& tags+=.tags,tags
endif
set showtabline=2
set laststatus=2
set ambiwidth=double
set noswapfile
set nofoldenable

set cursorline

""" highlight
highlight clear CursorLine
highlight CursorLine gui=underline cterm=underline

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
nnoremap x "_x
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

""" comment out
nmap <C-Z> <Plug>(caw:i:toggle)
vmap <C-Z> <Plug>(caw:i:toggle)
"""

function! GetCursorSyntaxGroup()
    echo "hi<" .synIDattr(synID(line("."), col("."), 1), "name") . '> trans<'
        \   . synIDattr(synID(line("."), col("."), 0), "name") . '> lo<'
        \   . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name") . ">"
endfunction

map <Leader>s :call GetCursorSyntaxGroup()<CR>

source ${HOME}/.vim/binary.vim
