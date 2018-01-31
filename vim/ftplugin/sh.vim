" Description:
"
"   Shell script editing plugin for vim
"
" Author:
"
"   DONG Li, dongli@lasg.iap.ac.cn

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" TAB stuffs
setlocal expandtab
setlocal tabstop=4

" indentation stuffs
setlocal shiftwidth=4
setlocal autoindent
setlocal smartindent
