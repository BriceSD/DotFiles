local conf = {
    -- close lazy panel with esc
    vim.api.nvim_create_autocmd("FileType", {
        pattern = {
            "lazy",
        },
        callback = function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = event.buf, silent = true })
        end
    })
}
return conf
