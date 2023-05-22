-- See `:help telescope.builtin`
local builtin = require('telescope.builtin')

require("telescope").setup({
    extensions = {
        undo = {
            use_delta = true,
            use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
            side_by_side = false,
            --layout_strategy = "vertical",
            layout_config = {
                preview_height = 0.8,
            },
            diff_context_lines = vim.o.scrolloff,
            entry_format = "state #$ID, $STAT, $TIME",
            mappings = {
                i = {
                    -- IMPORTANT: Note that telescope-undo must be available when telescope is configured if
                    -- you want to replicate these defaults and use the following actions. This means
                    -- installing as a dependency of telescope in it's `requirements` and loading this
                    -- extension from there instead of having the separate plugin definition as outlined
                    -- above.
                    ["<cr>"] = require("telescope-undo.actions").yank_additions,
                    ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
                    ["<C-cr>"] = require("telescope-undo.actions").restore,
                },
            },
        },
    },
})
require("telescope").load_extension("undo")
vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")

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
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[ ] Find existing buffers' })
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
