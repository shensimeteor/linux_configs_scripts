" Description:
"
"   Li Dong's VIM editing plugins
"
" Author:
"
"   Li Dong, dongli@lasg.iap.ac.cn

if exists("g:loaded_dl_filetypes")
	finish
endif
let g:loaded_dl_filetypes = 1

autocmd BufRead,BufNewFile *.ncl setfiletype ncl
