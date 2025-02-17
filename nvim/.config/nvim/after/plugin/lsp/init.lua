local lspconfig = require("lspconfig")
local lsp_zero = require("lsp-zero")
local ih = require('lsp-inlayhints')

ih.setup()

lsp_zero.preset({
    name = 'recommended',
    set_lsp_keymaps = false,
    suggest_lsp_servers = true,
    sign_icons = false
})
lsp_zero.ensure_installed({
    'eslint',
    'tsserver',
    'rust_analyzer',
})

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- nvim-cmp setup
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local autocomplete_group = vim.api.nvim_create_augroup('vimrc_autocompletion', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'sql', 'mysql', 'plsql' },
    callback = function()
        cmp.setup.buffer({
            sources = {
                { name = 'vim-dadbod-completion' },
                { name = 'buffer' },
                { name = 'vsnip' },
            },
        })
    end,
    group = autocomplete_group,
})

local luasnip = require('luasnip')
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
        ['<C-s>'] = cmp.mapping.confirm {
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


local cmp_mappings = lsp_zero.defaults.cmp_mappings({
    ['<C-s>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

cmp_mappings['<C-u>'] = nil
cmp_mappings['<C-x>'] = nil

cmp_mappings['<F4>'] = nil

lsp_zero.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp_zero.set_preferences({
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

lsp_zero.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts) -- Goto Declaration
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    --vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    -- vim.keymap.set("n", "<leader>vrl", function() vim.lsp.buf.references() end,
    --     { desc = '[V]iew [R]eferences [L]ist' })
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", '<C-s>', function() vim.lsp.buf.signature_help() end, opts) -- Show Signature

    vim.keymap.set("n", "<leader>.", vim.lsp.buf.format)

    --vim.keymap.set("n", 'gr', 'lsp_references')                                         -- Goto References
    -- vim.keymap.set("n", "VR", function() vim.lsp.buf.references() end,
    --     { desc = '[V]iew [R]eferences' })
    --vim.keymap.set("n", '<leader>gi', '<cmd>lua vim.lsp.implementations<CR>') -- Goto Implementations
    vim.keymap.set({ 'v', 'n' }, '<Leader>a', vim.lsp.buf.code_action)


    -- vim.keymap.set("n", '<Leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    -- vim.keymap.set("n", '<Leader>wa', function() vim.lsp.buf.add_workspace_folder() end, opts)
    -- vim.keymap.set("n", '<Leader>wr', function() vim.lsp.buf.remove_workspace_folder() end, opts)

    -- Diagnostics:
    vim.keymap.set("n", 'dl', function() vim.diagnostic.goto_prev() end, opts) -- Diagnostics Previous
    vim.keymap.set("n", 'dn', function() vim.diagnostic.goto_next() end, opts) -- Diagnostics Next
    --vim.keymap.set("n", '<Leader>dl', 'diagnostics')
    -- vim.keymap.set("n", '<Leader>ld', '<cmd>Telescope diagnostics<CR>')                 -- List Diagnotics
    -- vim.keymap.set("n", '<Leader>ll', function() vim.diagnostic.setloclist() end, opts) -- List Location List
    -- vim.keymap.set("n", '<Leader>lf', function() vim.diagnostic.setqflist() end, opts)  -- List quickFix
    -- Show diagnostic popup
    -- vim.keymap.set("n", "<Leader>df", function()
    --         vim.diagnostic.open_float(nil, { focusable = false })
    --     end,
    --     opts
    -- )
end)


vim.diagnostic.config({
    virtual_text = true
})


-- (Optional) Configure lua language server for neovim
--lspconfig.lua_ls.setup(lsp_zero.nvim_lua_ls())
lspconfig.lua_ls.setup({
    on_attach = function(client, bufnr)
        ih.on_attach(client, bufnr)
    end,
    settings = {
        Lua = {
            hint = {
                enable = true,
            },
        },
    },
})

local function rename_ts_file()
    local source_file, target_file

    vim.ui.input({
            prompt = "Source : ",
            completion = "file",
            default = vim.api.nvim_buf_get_name(0)
        },
        function(input)
            source_file = input
        end
    )
    vim.ui.input({
            prompt = "Target : ",
            completion = "file",
            default = source_file
        },
        function(input)
            target_file = input
        end
    )

    local params = {
        command = "_typescript.applyRenameFile",
        arguments = {
            {
                sourceUri = source_file,
                targetUri = target_file,
            },
        },
        title = ""
    }

    vim.lsp.util.rename(source_file, target_file, {})
    vim.lsp.buf.execute_command(params)
end

vim.keymap.set("n", "<leader>rf", function() rename_ts_file() end)

lspconfig.tsserver.setup {
    on_attach = function(client, bufnr)
        ih.on_attach(client, bufnr)
    end,
    commands = {
        RenameFile = {
            rename_ts_file,
            description = "Rename File"
        },
    },
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            }
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            }
        }
    },
    capabilities = capabilities,
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics,
            { virtual_text = false, signs = true, update_in_insert = false, underline = true }
        ),
    }
}

require('lspconfig').eslint.setup {
    capabilities = capabilities
}

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
    d = {
        name = 'Diagnostics',
        n = { '[Diagnostics] Goto Next' },
        p = { '[Diagnostics] Goto Previous' },
    },
    v = {
        name = 'View',
        r = { 'References' },
    }
}
lsp_zero.setup()
