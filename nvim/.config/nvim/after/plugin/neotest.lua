require("neotest").setup({
    adapters = {
        -- require("neotest-python")({
        --   dap = { justMyCode = false },
        -- }),
        -- require("neotest-plenary"),
        -- require("neotest-vim-test")({
        --   ignore_file_types = { "python", "vim", "lua" },
        -- }),
        require("neotest-rust") {
            args = { "--no-capture" },
            dap_adapter = "lldb",
        }
    },
})

vim.keymap.set('n', "<leader>nt", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run File" })
vim.keymap.set('n', "<leader>nT", function() require("neotest").run.run(vim.loop.cwd()) end,
    { desc = "Run All Test Files" })
vim.keymap.set('n', "<leader>nr", function() require("neotest").run.run() end, { desc = "Run Nearest" })
vim.keymap.set('n', "<leader>ns", function() require("neotest").summary.toggle() end, { desc = "Toggle Summary" })
vim.keymap.set('n', "<leader>no", function() require("neotest").output.open({ enter = true, auto_close = true }) end,
    { desc = "Show Output" })
vim.keymap.set('n', "<leader>nO", function() require("neotest").output_panel.toggle() end,
    { desc = "Toggle Output Panel" })
vim.keymap.set('n', "<leader>nS", function() require("neotest").run.stop() end, { desc = "Stop" })
