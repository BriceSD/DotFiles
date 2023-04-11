-- See `:help telescope.builtin`
local builtin = require('telescope.builtin')

local nmap = function(keys, func, desc)
    if desc then
        desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end

nmap('<leader>pf', builtin.find_files, 'Find Files')
nmap('<C-p>', builtin.git_files)
nmap("<leader>vrt", builtin.lsp_references, '[V]iew [R]eferences [T]elescope')
nmap('<leader>vds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
nmap('<leader>vws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>,', builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find()
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
--vim.keymap.set('n', '<leader>ps', function()
--    builtin.grep_string({ search = vim.fn.input("Grep > ") });
--end)



local whichkey = require 'which-key'
whichkey.register {
    ['<Leader>'] = {
        v = {
            name = 'View',
            r = {
                name = 'References',
            },
            d = {
                name = 'Document',
                s = { 'Symboles' },
            },
            w = {
                name = 'Workspace',
                s = { 'Symboles' },
            },
        },
    },
}
