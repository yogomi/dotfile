" Vim syntax file
" Language:         reStructuredText documentation format
" Maintainer:       Makoto Yano <yan133@gmail.com>
" Latest Revision:  2013-12-03
" Remark:           extension of rst syntax

let s:cpo_save = &cpo
set cpo&vim

syn match   rstTableLines           contained display '|\|+\%(=\+\|-\+\)\='

let &cpo = s:cpo_save
unlet s:cpo_save
