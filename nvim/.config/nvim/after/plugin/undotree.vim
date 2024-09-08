"Custom key mappings: add this function to your vimrc.
"You can define whatever mapping as you like, this is a hook function which
"will be called after undotree window initialized.
"
nmap <leader>u :UndotreeToggle<CR>
let g:undotree_WindowLayout = 2

function g:Undotree_CustomMap()
    map <buffer> <tab> J
    map <buffer> <s-tab> K
endfunction
