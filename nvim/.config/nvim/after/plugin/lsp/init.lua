local lspconfig = require("lspconfig")
local lsp = require("lsp-zero")
--lsp.preset("recommended")
lsp.preset({
    name = 'recommended',
    set_lsp_keymaps = false,
    suggest_lsp_servers = true,
    sign_icons = false
})
lsp.ensure_installed({
    'tsserver',
    'rust_analyzer',
    'eslint',
    --    'sumneko_lua',
})

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require'lspconfig'.tsserver.setup{
  capabilities = capabilities,
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        { virtual_text = false, signs = true, update_in_insert = false, underline = true}
    ),
  }
}



-- nvim-cmp setup
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local luasnip = require 'luasnip'
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        --['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
    },
    sources = cmp.config.sources({
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = "crates" },
    }, {
        { name = 'path' },
        { name = 'buffer' },
    })
})


local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<Enter>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

cmp_mappings['<C-u>'] = nil
cmp_mappings['<C-x>'] = nil

cmp_mappings['<F4>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})


local function buf_set_option(...)
    vim.api.nvim_buf_set_option(0, ...)
end

buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts) -- Goto Declaration
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    --vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    --vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    --vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    --vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrl", function() vim.lsp.buf.references() end,
        { desc = '[V]iew [R]eferences [L]ist' })
    --vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", '<C-s>', function() vim.lsp.buf.signature_help() end, opts) -- Show Signature


    vim.keymap.set("n", "<leader>,", vim.lsp.buf.format)

    --vim.keymap.set("n", 'gr', 'lsp_references')                                         -- Goto References
    vim.keymap.set("n", 'gI', '<cmd>lua vim.lsp.implementations<CR>') -- Goto Implementations
    --vim.keymap.set("n", '<Leader>cr', function() vim.lsp.buf.rename() end, opts) -- Code Rename
    vim.keymap.set({ 'v', 'n' }, '<Leader>ca', vim.lsp.buf.code_action)


    vim.keymap.set("n", '<Leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    vim.keymap.set("n", '<Leader>wa', function() vim.lsp.buf.add_workspace_folder() end, opts)
    vim.keymap.set("n", '<Leader>wr', function() vim.lsp.buf.remove_workspace_folder() end, opts)

    -- Diagnostics:
    --vim.keymap.set("n", '<Leader>dl', function() vim.diagnostic.open_float() end, opts) -- Diagnostics
    vim.keymap.set("n", 'dp', function() vim.diagnostic.goto_prev() end, opts)          -- Diagnostics Previous
    vim.keymap.set("n", 'dl', function() vim.diagnostic.goto_prev() end, opts)          -- Diagnostics Previous
    vim.keymap.set("n", 'dn', function() vim.diagnostic.goto_next() end, opts)          -- Diagnostics Next
    --vim.keymap.set("n", '<Leader>dl', 'diagnostics')
    vim.keymap.set("n", '<Leader>ld', '<cmd>Telescope diagnostics<CR>')                 -- List Diagnotics
    vim.keymap.set("n", '<Leader>ll', function() vim.diagnostic.setloclist() end, opts) -- List Location List
    vim.keymap.set("n", '<Leader>lf', function() vim.diagnostic.setqflist() end, opts)  -- List quickFix
    -- Show diagnostic popup
    vim.keymap.set("n", "<Leader>df", function()
            vim.diagnostic.open_float(nil, { focusable = false })
        end,
        opts
    )
end)


vim.diagnostic.config({
    virtual_text = true
})


-- (Optional) Configure lua language server for neovim
lspconfig.lua_ls.setup(lsp.nvim_lua_ls())


-- Latex setup
lspconfig.ltex.setup({
    filetypes = { "tex", "vimwiki", "markdown", "md", "pandoc", "vimwiki.markdown.pandoc" },
    flags = { debounce_text_changes = 300 },
    settings = {
        ltex = {
            language = "en"
            -- language = "fr"
        }
    },
    on_attach = on_attach,
})

-- require('lspconfig').ltex.setup({
--   filetypes = {  "markdown", "md", "tex" },  flags = { debounce_text_changes = 300 },
--   settings = {
--     ltex = {
--       language = "fr-FR",
--       setenceCacheSize = 2000,
--       additionalRules = {
--       	enablePickyRules = true,
--       	motherTongue = "de-FR",
--       },
--       trace = { server = "verbose" },
--       disabledRules = {},
--       hiddenFalsePositives = {},
--       username = "x@y.z",
--       apiKey = "tete",
--     }
--   },
--   on_attach = on_attach,
-- })


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
            --d = { '[Diagnostics] List Diagnostics' },
            f = { '[Diagnostics] Quickfix List' },
            --l = { '[Diagnostics] Location List' },
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
            r = { 'References' },
        }
    }
}
lsp.setup()
