set encoding=utf-8
set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=utf-8,sjis,euc-jp " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される

" ファイルタイプによる動作の変更を有効にする
filetype plugin on

" □や○文字が崩れる問題を解決
set ambiwidth=double

" swapファイルを作成しない
set noswapfile

" クリップボードと無名レジスタを共有
set clipboard+=unnamed

if has("win64")
  let ostype = 'windows'
else
  let ostype = system('uname')
endif

augroup MyAutoCmd
    autocmd!
augroup END

if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \  exe "normal! g'\"" |
  \  endif
endif

call plug#begin('~/.local/share/nvim/plugged')

if !has("win64")
  Plug 'Shougo/vimproc.vim', {'dir': '~/.vim/plugged/vimproc.vim', 'do': 'make'}
endif

" My Bundles here:
"
Plug 'tpope/vim-fugitive'
Plug 'Lokaltog/vim-easymotion'
Plug 'rstacruz/sparkup'
Plug 'tyru/caw.vim'

""" for html and js
Plug 'mattn/emmet-vim'
let g:user_emmet_settings = {
      \  'javascript.jsx' : {
      \      'extends': 'jsx',
      \      'quote_char': "'",
      \  },
      \}

Plug 'hail2u/vim-css3-syntax'

""" syntastic lint系のため
Plug 'vim-syntastic/syntastic'

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn
"""


Plug 'Shougo/deoplete.nvim'
if !has('nvim')
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'Shougo/neosnippet', {'on': 'NeoSnippetClearMarkers'}
Plug 'Shougo/neosnippet-snippets'

Plug 'thinca/vim-quickrun'

Plug 'altercation/vim-colors-solarized'

Plug 'Shougo/vimfiler.vim'
" Non github repos
Plug 'vim-scripts/command-t'


Plug 'myhere/vim-nodejs-complete'

Plug 'embear/vim-localvimrc'

let g:localvimrc_persistent = 1

runtime! include/*.vim

call plug#end()

""" key bind

" <space> . でinit.vimを開く <space> s でvnvim.initを再読み込み
nnoremap <Space>. :<C-u>edit $MYVIMRC<Enter>
nnoremap <Space>s. :<C-u>source $MYVIMRC<Enter>

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

" cpplint
" autocmd BufWritePost *.h,*.cpp,*.cc call Cpplint()
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

" ノーマルモードで;と:を入れ替える
nnoremap ; :

""" deoplete
let g:deoplete#enable_at_startup = 1

" 補完ウィンドウの設定
set completeopt=menuone

" 起動時に有効化

" " 大文字が入力されるまで大文字小文字の区別を無視する
" call deoplete#custom#option({
"  \ 'auto_complete_delay':  0,
"  \ 'smart_case': v:true,
"  \ 'max_list': 50,
"  \ 'keyword_patterns': {'defalut': '\h\w*'}
"  \ })

" シンタックスをキャッシュするときの最小文字長
let g:deoplete#sources#syntax#min_keyward_length = 3

" " ディクショナリ定義
let g:deoplete#sources#dictionary#dictionaries = {
   \ 'default' : '',
   \ 'php' : $HOME . '/.vim/dict/php.dict',
   \ 'ctp' : $HOME . '/.vim/dict/php.dict'
   \ }


" 前回行われた補完をキャンセルします
inoremap <expr><C-g> deoplete#undo_completion()

" 補完候補のなかから、共通する部分を補完します
inoremap <expr><C-l> deoplete#complete_common_string()

" 改行で補完ウィンドウを閉じる
inoremap <expr><CR> deoplete#smart_close_popup() . "\<CR>"

"tabで補完候補の選択を行う
inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

if !has("win64")
  " <C-h>や<BS>を押したときに確実にポップアップを削除します
  inoremap <expr><C-h> deoplete#smart_close_popup().”\<C-h>”
endif

" 現在選択している候補を確定します
inoremap <expr><C-y> deoplete#close_popup()

" 現在選択している候補をキャンセルし、ポップアップを閉じます
inoremap <expr><C-e> deoplete#cancel_popup()

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

""" highlight
if !has("win64")
  set cursorline

  highlight clear CursorLine
  highlight CursorLine gui=underline cterm=underline
endif

highlight Title term=bold ctermfg=121 gui=bold guifg=#60ff60
"""

""" quickrun
if !exists("g:quickrun_config")
  let g:quickrun_config={}
endif
let g:quickrun_config["_"] = {
  \ "outputter/buffer/split" : ":rightbelow 8sp"
  \ }
let g:quickrun_config.cpp = {
  \   'command': 'g++',
  \   'cmdopt': '-std=c++17'
  \ }
"""

""" cache
nnoremap x "_x

if has('nvim')
  set backupdir=~/.nvimcache/bak
  set viminfo& viminfo+=n~/.nvimcache/viminfo
  set undodir=~/.nvimcache/undo
else
  set backupdir=~/.vimcache/bak
  set viminfo& viminfo+=n~/.vimcache/viminfo
  set undodir=~/.vimcache/undo
endif

set undofile

" for snippet_complete marker
" conceal in insert (i), normal (n) and visual (v) modes
set conceallevel=2 concealcursor=inv
set colorcolumn=99

"""

""" comment out
nmap <C-Z> <Plug>(caw:hatpos:toggle)
vmap <C-Z> <Plug>(caw:hatpos:toggle)
"""

function! GetCursorSyntaxGroup()
    echo "hi<" .synIDattr(synID(line("."), col("."), 1), "name") . '> trans<'
        \   . synIDattr(synID(line("."), col("."), 0), "name") . '> lo<'
        \   . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name") . ">"
endfunction

map <Leader>s :call GetCursorSyntaxGroup()<CR>

source ~/.vim/binary.vim
