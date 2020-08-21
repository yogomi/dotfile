au BufRead,BufNewFile *.jsx set filetype=javascript

call dein#add('othree/yajs.vim', { 'for': ['javascript'] })
call dein#add('othree/es.next.syntax.vim', { 'for': ['javascript'] })
call dein#add('othree/javascript-libraries-syntax.vim', { 'for': ['javascript'] })

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

call dein#add('othree/html5.vim')

call dein#add('mxw/vim-jsx', { 'for': ['javascript'] })
call dein#add('ternjs/tern_for_vim', { 'for': ['javascript'], 'do': 'npm install' })

" ESLint configuration
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

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
