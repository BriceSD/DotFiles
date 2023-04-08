vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

local Brice_Fugitive = vim.api.nvim_create_augroup("Brice_Fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
    group = Brice_Fugitive,
    pattern = "*",
    callback = function()
        if vim.bo.ft ~= "fugitive" then
            return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "<leader>p", function()
            vim.cmd.Git('push')
        end, opts)

        -- rebase always
        vim.keymap.set("n", "<leader>P", function()
            vim.cmd.Git({ 'rebase' })
        end, opts)

        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
        -- needed if i did not set the branch up correctly
        vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);


        vim.keymap.set("n", "<leader>gr", "<cmd>diffget //2<CR>");
        vim.keymap.set("n", "<leader>ga", "<cmd>diffget //3<CR>");

        -- Manage changing branch with WIP/Undo commit
        -- See https://nicolaiarocci.com/git-worktree-vs-git-savepoints/
        -- Commit all files (even untracked ones) with SAVEPOINT message
        vim.keymap.set("n", "<leader>sa", function()
            vim.cmd.Git('add -A')
            vim.cmd.Git('commit -m "SAVEPOINT"')
        end, opts)

        -- Commit only tracked files with WIP message
        vim.keymap.set("n", "<leader>st", function()
            vim.cmd.Git('add -u')
            vim.cmd.Git('commit -m "WIP"')
        end, opts)

        -- Undo last commit
        vim.keymap.set("n", "<leader>su", function()
            vim.cmd.Git('reset HEAD^ --mixed')
        end, opts)

        -- adds changes in the working tree to a WIPE SAVEPOINT commit, then it wipes the commit
        -- still accessible through "reflog"
        vim.keymap.set("n", "<leader>sx", function()
            vim.cmd.Git('add -A')
            vim.cmd.Git('commit -qm "WIPE SAVEPOINT"')
            vim.cmd.Git('reset HEAD~1 --hard')
        end, opts)
    end,
})
