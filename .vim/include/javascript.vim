au BufRead,BufNewFile *.jsx set filetype=javascript.jsx

NeoBundle 'othree/yajs.vim', { 'for': ['javascript', 'javascript.jsx'] }
NeoBundle 'othree/es.next.syntax.vim', { 'for': ['javascript', 'javascript.jsx'] }
NeoBundle 'othree/javascript-libraries-syntax.vim', { 'for': ['javascript', 'javascript.jsx'] }

function! EnableJavascript()
  " Setup used libraries
  let g:used_javascript_libs = 'react'
  let b:javascript_lib_use_react = 1
endfunction

augroup MyVimrc
  autocmd!
augroup END
autocmd MyVimrc FileType javascript,javascript.jsx call EnableJavascript()

" command! EsFix :call vimproc#system_bg("eslint " . expand("%"))
" augroup javascript
"   autocmd!
"   autocmd BufWrite *.js,*.jsx EsFix
" augroup END

NeoBundle 'othree/html5.vim'

NeoBundle 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] }
NeoBundle 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install' }
