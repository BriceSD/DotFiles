-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'java', 'bash' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,

    highlight = { enable = true },
    indent = { enable = true, disable = { 'python' } },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<M-space>',
            node_incremental = '<M-space>',
            --scope_incremental = '<c-m-s>',
            node_decremental = '<M-S-space>',
        },
    },
    textobjects = {
        enable = true,
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']['] = '@class.outer',
                [']&'] = '@function.outer'
            },
            goto_next_end = {
                [']]'] = '@class.outer',
                [']m'] = '@function.outer'
            },
            goto_previous_start = {
                ['[['] = '@class.outer',
                ['[&'] = '@function.outer'
            },
            goto_previous_end = {
                ['[m'] = '@function.outer',
                ['[]'] = '@class.outer'
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>pmr'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>pml'] = '@parameter.inner',
            },
        },
        lsp_interop = {
            enable = true,
            floating_preview_opts = {},
            peek_definition_code = {
                ["<leader>vdf"] = "@function.outer",
                ["<leader>vdF"] = "@class.outer",
            },
        },
    },
}
