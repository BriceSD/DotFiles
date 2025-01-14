local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>o", mark.add_file)
vim.keymap.set("n", "<C-s>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-space>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-h>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-a>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-e>", function() ui.nav_file(4) end)
vim.keymap.set("n", "<C-i>", function() ui.nav_file(5) end)

require("harpoon").setup({
    tabline = true
})
