au BufRead,BufNewFile *.jsx set filetype=javascript

NeoBundle 'othree/yajs.vim', { 'for': ['javascript'] }
NeoBundle 'othree/es.next.syntax.vim', { 'for': ['javascript'] }
NeoBundle 'othree/javascript-libraries-syntax.vim', { 'for': ['javascript'] }

function! EnableJavascript()
  " Setup used libraries
  let g:used_javascript_libs = 'react'
  let b:javascript_lib_use_react = 1
endfunction

augroup MyVimrc
  autocmd!
augroup END
autocmd MyVimrc FileType javascript call EnableJavascript()

" command! EsFix :call vimproc#system_bg("eslint " . expand("%"))
" augroup javascript
"   autocmd!
"   autocmd BufWrite *.js,*.jsx EsFix
" augroup END

NeoBundle 'othree/html5.vim'

NeoBundle 'mxw/vim-jsx', { 'for': ['javascript'] }
NeoBundle 'ternjs/tern_for_vim', { 'for': ['javascript'], 'do': 'npm install' }

" ESLint configuration
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['eslint']

function! SetNodejsLintConfig()
  if filereadable('.eslint_config/nodejs.json')
    let g:syntastic_javascript_eslint_args = '-c .eslint_config/nodejs.json'
  endif
endfunction

function! SetECMAScriptLintConfig()
  if filereadable('.eslint_config/es.json')
    let g:syntastic_javascript_eslint_args = '-c .eslint_config/es.json'
  endif
endfunction

function! SetReactLintConfig()
  if filereadable('.eslint_config/react.json')
    let g:syntastic_javascript_eslint_args = '-c .eslint_config/react.json'
  endif
endfunction

autocmd BufRead,BufNewFile *.js call SetNodejsLintConfig()
autocmd BufRead,BufNewFile *.es call SetECMAScriptLintConfig()
autocmd BufRead,BufNewFile *.jsx call SetReactLintConfig()
