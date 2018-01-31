" Description:
"
"   NCL editing plugin for vim
"
" Author:
"
"   Li Dong, dongli@lasg.iap.ac.cn

if exists("b:did_ncl_ftplugin")
	finish
endif
let b:did_ncl_ftplugin = 1

" TAB stuffs
setlocal expandtab
setlocal tabstop=4

" indentation stuffs
setlocal shiftwidth=4
setlocal autoindent
setlocal smartindent

" completion stuffs
setlocal dictionary=~/.vim/dictionary/ncl.dic
setlocal complete-=k complete+=k
setlocal wildmode=list:full
setlocal wildmenu

