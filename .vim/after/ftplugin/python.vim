if exists('b:did_ftplugin_python')
    finish
endif
let b:did_ftplugin_python=1

setlocal commentstring=#%s
let g:python_highlight_all=1
set expandtab
set tabstop=8
set softtabstop=4
set shiftwidth=4
