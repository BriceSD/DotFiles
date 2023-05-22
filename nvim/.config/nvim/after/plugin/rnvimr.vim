" Make Ranger replace Netrw and be the file explorer
" Not working right now
let g:rnvimr_enable_ex = 1
let g:NERDTreeHijackNetrw = 0

" Make Ranger to be hidden after picking a file
let g:rnvimr_enable_picker = 1

" Replace `$EDITOR` candidate with this command to open the selected file
let g:rnvimr_edit_cmd = 'drop'

" Disable a border for floating window
"let g:rnvimr_draw_border = 0

" Hide the files included in gitignore
let g:rnvimr_hide_gitignore = 1

nmap <space>ro :RnvimrToggle<CR>
