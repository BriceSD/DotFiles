--TrySource 'lsp.omnisharp'
--TrySource 'lsp.typescript'
--TrySource 'lsp.viml'

vim.diagnostic.config {
    virtual_text = true,
}

local function buf_set_option(...)
    vim.api.nvim_buf_set_option(0, ...)
end

buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
-- stylua: ignore start
vim.keymap.set("n", 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>') -- Goto Declaration
--vim.keymap.set("n", 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')  -- Goto Definition

vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
--vim.keymap.set("N", 'K', '<cmd>lua vim.lsp.buf.hover()<CR>') -- Well, K is K
--TrySource 'lsp.rust' -- Have this after K mapping so it gets remapped

--vim.keymap.set("n", 'gr', 'lsp_references')                                         -- Goto References
vim.keymap.set("n", 'gI', 'lsp_implementations')                                    -- Goto Implementations

--vim.keymap.set("n", '<Leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>') -- Code Rename
vim.keymap.set({ 'v', 'n' }, '<Leader>ca', vim.lsp.buf.code_action)

vim.keymap.set("i", '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>') -- Show Signature

vim.keymap.set("n", '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
vim.keymap.set("n", '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
vim.keymap.set("n", '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')

-- Diagnostics:

vim.keymap.set("n", '<Leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>') -- Diagnostics
vim.keymap.set("n", 'dp', '<cmd>lua vim.diagnostic.goto_prev()<CR>')         -- Diagnostics Previous
vim.keymap.set("n", 'dn', '<cmd>lua vim.diagnostic.goto_next()<CR>')         -- Diagnostics Next
-- vim.keymap.set("n", '<Leader>dl', 'diagnostics')
-- vim.keymap.set("N", '<Leader>ld', '<cmd>Telescope diagnostics<CR>') -- List Diagnotics
vim.keymap.set("n", '<Leader>ll', '<cmd>lua vim.diagnostic.setloclist()<CR>') -- List Location List
vim.keymap.set("n", '<Leader>lf', '<cmd>lua vim.diagnostic.setqflist()<CR>')  -- List quickFix

local whichkey = require 'which-key'
whichkey.register {
    g = {
        name = 'LSP', -- optional group name
        D = { '[LSP] Goto Declaration' },
        I = { '[LSP] Show Implementations' },
        K = { '[LSP] Display Hover Info' },
        d = { '[LSP] Goto definition' },
    },
    ['<Leader>'] = {
        c = {
            name = 'LSP',
            a = { '[LSP] Code Actions' },
            ca = { '[LSP] Code Actions All' },
            r = { '[LSP] Rename Symbol' },
        },
        w = {
            name = 'LSP',
            a = { 'Add Workspace Folder' },
            l = { 'List Workspace Folders' },
            r = { 'Remove Workspace Folders' },
            d = { 'List Document Symbols in Current Document' },
            w = { 'List Document Symbols in Current Workspace' },
        },
        name = 'Diagnostics',
        d = { '[Diagnostics] Display Line Diagnostics' },
        l = {
            name = 'Diagnostics',
            d = { '[Diagnostics] List Diagnostics' },
            f = { '[Diagnostics] Quickfix List' },
            l = { '[Diagnostics] Location List' },
        },
    },
    d = {
        name = 'Diagnostics',
        n = { '[Diagnostics] Goto Next' },
        p = { '[Diagnostics] Goto Previous' },
    },
    v = {
        name = 'View',
        r = {
            r = { 'References'},
        }
    }
}
-- stylua: ignore end
