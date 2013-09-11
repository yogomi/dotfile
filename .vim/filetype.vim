augroup filetypedetect
    au BufRead,BufNewFile *.py setfiletype python
    au BufRead,BufNewFile *.c setfiletype c
    au BufRead,BufNewFile *.cc setfiletype c
    au BufRead,BufNewFile *.cpp setfiletype c
    au BufRead,BufNewFile *.h setfiletype c
    au BufRead,BufNewFile *.hpp setfiletype c
augroup END
