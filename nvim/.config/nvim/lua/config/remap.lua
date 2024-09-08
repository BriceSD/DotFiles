vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pb", vim.cmd.Ex)

vim.keymap.set("v", "A", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "H", ":m '>+1<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Does this work ?
vim.keymap.set("n", "[&", "[&zz")
vim.keymap.set("n", "]&", "]&zz")
--vim.keymap.set("n", "<leader>vwm", function()
--    require("vim-with-me").StartVimWithMe()
--end)
--vim.keymap.set("n", "<leader>svwm", function()
--    require("vim-with-me").StopVimWithMe()
--end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>D", [["_d]])

-- Go to next jump list item
vim.keymap.set("n", "<M-o>", "<C-i>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })


--vim.keymap.set("n", "<leader>q", "<cmd>:wa<CR><cmd>!cargo fmt<CR><CR>")

-- navigate splits using alt
vim.keymap.set("n", "<M-y>", "<C-w>h")
vim.keymap.set("n", "<M-h>", "<C-w>j")
vim.keymap.set("n", "<M-a>", "<C-w>k")
vim.keymap.set("n", "<M-e>", "<C-w>l")

-- resize splits using alt
vim.keymap.set("n", "<M-Y>", "<C-w><")
vim.keymap.set("n", "<M-H>", "<C-w>+")
vim.keymap.set("n", "<M-E>", "<C-w>>")
vim.keymap.set("n", "<M-A>", "<C-w>-")

-- Kitty dosn't let you use C-^ or C-; or ...
-- https://github.com/kovidgoyal/kitty/issues/1629#issuecomment-494299618
--vim.keymap.set("n", "<C-g>", "<C-^>")
--vim.keymap.set("n", "<M-g>", "<C-g>")

-- Zoom in
vim.keymap.set("n", "<c-w><c-o>", ":tabnew %<CR>")
-- Zoom out
vim.keymap.set("n", "<c-w><c-u>", ":tabclose<CR>")
