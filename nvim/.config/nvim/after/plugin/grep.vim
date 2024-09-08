" Set ripgrep as default :grep 
if executable("rg")
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --engine\ auto
  set grepformat=%f:%l:%c:%m
endif

" function! MoshGitPath()
"   let g:gitdir=substitute(system("git rev-parse --show-toplevel 2>&1 | grep -v fatal:"),'\n','','g')
"   if  g:gitdir != '' && isdirectory(g:gitdir) && index(split(&path, ","),g:gitdir) < 0
"     exe "set path+=".g:gitdir."/*"
"   endif
" endfunction
" command! MoshGitPath :call MoshGitPath()
