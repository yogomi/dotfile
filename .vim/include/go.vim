call dein#add('fatih/vim-go.git')

let g:go_template_autocreate = 0
let g:go_fmt_command = "gofmt"
let g:syntastic_go_checkers = ['golint', 'errcheck']
