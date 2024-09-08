local tr = require("trouble")
tr.setup {
    modes = {
        mydiags = {
            mode = "diagnostics", -- inherit from diagnostics mode
            filter = {
                any = {
                    buf = 0,                                      -- current buffer
                    {
                        severity = vim.diagnostic.severity.ERROR, -- errors only
                        -- limit to files in the current project
                        function(item)
                            return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
                        end,
                    },
                },
            },
            -- preview = {
            --     type = "split",
            --     relative = "win",
            --     position = "right",
            --     size = 0.5,
            -- },
        },
    },
}

vim.keymap.set("n", "<leader>tt", "<cmd>Trouble lsp toggle focus=true win.position=right win.size=0.4<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>tD", "<cmd>Trouble diagnostics toggle focus=true<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>td", "<cmd>Trouble mydiags toggle focus=true<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>tl", "<cmd>Trouble loclist toggle focus=true<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>tq", "<cmd>Trouble qflist toggle focus=true<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>gr", "<cmd>Trouble lsp_references toggle focus=true<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>gi", "<cmd>Trouble lsp_implementations toggle focus=true<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>ts", "<cmd>Trouble symbols toggle focus=true win.size=0.3<cr>",
    { silent = true, noremap = true }
)
