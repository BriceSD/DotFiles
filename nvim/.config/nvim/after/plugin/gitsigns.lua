-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },
}

vim.keymap.set("n", "]c", "<cmd>Gitsigns next_hunk<cr>",
    { silent = true, noremap = true, desc = 'Next [c]hange' }
)
vim.keymap.set("n", "[c", "<cmd>Gitsigns prev_hunk<cr>",
    { silent = true, noremap = true, desc = 'Previous [c]hange' }
)
vim.keymap.set("n", "<leader>vcp", "<cmd>Gitsigns preview_hunk<cr>",
    { silent = true, noremap = true, desc = '[V]iew [c]hange [p]review' }
)
vim.keymap.set("n", "<leader>vdl", "<cmd>Gitsigns toggle_deleted<cr>",
    { silent = true, noremap = true, desc = '[V]iew [d]eleted [l]ines' }
)
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame<cr>",
    { silent = true, noremap = true, desc = '[G]it [b]lame' }
)
vim.keymap.set("n", "<leader>dt", "<cmd>Gitsigns diffthis<cr>",
    { silent = true, noremap = true, desc = '[D]iff [t]his' }
)
vim.keymap.set("n", "<leader>cr", "<cmd>Gitsigns reset_hunk<cr>",
    { silent = true, noremap = true, desc = '[C]hange [r]eset' }
)
