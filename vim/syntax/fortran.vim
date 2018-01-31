syntax match fortranCallProcedure /\(call \)\@<=\w\+\(\_[ ]*(\)\@=/
syntax match fortranDebug /\<\(stop\|print\)\>/
highlight link fortranCallProcedure ProcedureName
highlight link fortranDebug Error
