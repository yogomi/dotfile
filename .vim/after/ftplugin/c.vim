setlocal expandtab
setlocal tabstop=8
setlocal softtabstop=2
setlocal shiftwidth=2

function! NoExpandTabFunc()
  setlocal noexpandtab
  setlocal softtabstop=8
  setlocal shiftwidth=8
endfunction

function! ExpandTabFunc()
  setlocal expandtab
  setlocal softtabstop=2
  setlocal shiftwidth=2
endfunction

command! NoExpandTab call NoExpandTabFunc()
command! ExpandTab call ExpandTabFunc()

let g:syntastic_cpp_compiler_options = '--std=c++17'
