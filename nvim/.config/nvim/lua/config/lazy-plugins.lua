local plugins = {
    -- fuzzy finder and more
    {
        'nvim-telescope/telescope.nvim',
        --version = '0.1.1',
        -- or
        version = '0.1.x',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
        },
    },

    -- theme
    'rebelot/kanagawa.nvim',
    'nvim-lualine/lualine.nvim', -- Fancier statusline

    'numToStr/Comment.nvim',     -- 'gc' to comment visual regions/lines


    -- Tree Sitter
    {
        "nvim-treesitter/nvim-treesitter-textobjects", -- yank, delete etc around/in function and more
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-treesitter/playground', -- view AST of current file
            'nvim-treesitter/nvim-treesitter-context',
        }
    },


    -- Navigation between files
    'ThePrimeagen/harpoon', -- easy switch between 4 files by marking them

    -- Undo tree history
    'mbbill/undotree',

    -- Browse filesystem in a tree
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v2.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
            'MunifTanjim/nui.nvim',
        },
    },

    -- FAST Navigation. Forget horizontal native navigation
    {
        'ggandor/leap.nvim',
        'ggandor/leap-spooky.nvim',
        dependencies = {
            'tpope/vim-repeat',
        },
    },

    -- Git
    {
        'tpope/vim-fugitive',             -- git integration/wrapper
        'lewis6991/gitsigns.nvim',        -- git signs left of lines
        'ThePrimeagen/git-worktree.nvim', -- git worktree wrapper
        'sindrets/diffview.nvim',         -- git diff UI
        dependencies = {
            'nvim-lua/plenary.nvim',
        }
    },

    -- Highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex
    'RRethy/vim-illuminate',


    -- Refactoring
    {
        'ThePrimeagen/refactoring.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-treesitter/nvim-treesitter' },
        }
    },


    -- plugins development LSP
    'folke/neodev.nvim',


    -- snipets
    {
        'hrsh7th/nvim-cmp',
        -- follow latest release.
        --version = 'v<CurrentMajor>.*',
        -- install jsregexp (optional!:).
        build = 'make install_jsregexp',
        config = [[require('config.nvim-cmp')]],
        dependencies = {
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-omni',
        },
    },

    -- LSP
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {
                -- Optional
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim',                opts = {} },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        },
    },


    -- Shows lsp status
    'nvim-lua/lsp-status.nvim',

    -- Rust related plugins
    {
        'simrat39/rust-tools.nvim', -- annotates Rust file with return types etc
        dependencies = {
            { 'neovim/nvim-lspconfig' },
            { 'nvim-lua/plenary.nvim' },
        },
    },


    -- Debugging
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter' }, -- needed
            { 'rcarriga/nvim-dap-ui' },            -- better ui
            { 'theHamsta/nvim-dap-virtual-text' }, -- annotates file with debug info
            { 'nvim-telescope/telescope-dap.nvim' },
            { 'nvim-telescope/telescope.nvim' },   -- needed for telescope-dap
            { 'jay-babu/mason-nvim-dap.nvim' },    -- ensure dap are installed through mason
            { 'mortepau/codicons.nvim' },          -- Debugger icons (font)
        },
    },


    {
        -- help to tell next available keys
        'folke/which-key.nvim',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require('which-key').setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    },
}
return plugins
