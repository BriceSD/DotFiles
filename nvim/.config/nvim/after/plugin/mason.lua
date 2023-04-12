require("mason").setup()
-- auto install dap
require("mason-nvim-dap").setup({
    ensure_installed = { "codelldb", "delve" }
})
