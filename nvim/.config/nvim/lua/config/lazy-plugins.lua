local plugins = {
    -- fuzzy finder and more
    {
        'nvim-telescope/telescope.nvim',
        --version = '0.1.1',
        -- or
        version = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            "debugloop/telescope-undo.nvim",
        },
    },

    -- Git history
    { 'rhysd/git-messenger.vim' },

    -- theme
    'rebelot/kanagawa.nvim',
    'nvim-lualine/lualine.nvim', -- Fancier statusline

    -- better edit experience
    'numToStr/Comment.nvim', -- 'gc' to comment visual regions/lines
    --'m4xshen/autoclose.nvim', -- manage auto pairs & closes brackets

    -- make one window fullscreen
    -- 'troydm/zoomwintab.vim',

    -- Markdown preview
    { "ellisonleao/glow.nvim",  config = true, cmd = "Glow" },
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },


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

    -- Browse filesystem with ranger
    {
        'kevinhwang91/rnvimr',
        -- # ArchLinux install all requirements is extremely convenient
        -- paru ranger python-pynvim ueberzug
        -- # ~ `ueberzug` can be replaced with `ueberzugpp` ~
        --
        -- # pip
        -- # Ueberzug/Ueberzugpp is not supported in macOS because it depends on X11
        -- pip3 install ueberzug
    },

    -- FAST Navigation. Forget horizontal native navigation
    {
        'ggandor/leap.nvim',
        'ggandor/leap-spooky.nvim',
        dependencies = {
            'tpope/vim-repeat',
        },
    },
    { 'tpope/vim-surround' },
    { 'tpope/vim-repeat' },
    -- <C-x> <C-a> to modify dates
    { 'tpope/vim-speeddating' },
    { 'tpope/vim-unimpaired' },

    -- RIP vimgrep
    { 'jremmen/vim-ripgrep' },

    { 'ThePrimeagen/vim-be-good' },

    -- Git
    {
        'tpope/vim-fugitive',             -- git integration/wrapper
        'lewis6991/gitsigns.nvim',        -- git signs left of lines
        'ThePrimeagen/git-worktree.nvim', -- git worktree wrapper
        'sindrets/diffview.nvim',         -- git diff UI
        'junegunn/gv.vim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        }
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "aaronhallaert/advanced-git-search.nvim",
        config = function()
            require("telescope").load_extension("advanced_git_search")
        end,
        dependencies = {
            "nvim-telescope/telescope.nvim",
            -- to show diff splits and open commits in browser
            "tpope/vim-fugitive",
            -- to open commits in browser with fugitive
            "tpope/vim-rhubarb",
            -- OPTIONAL: to replace the diff from fugitive with diffview.nvim
            -- (fugitive is still needed to open in browser)
            "sindrets/diffview.nvim",
        },
    },

    -- Highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex
    'RRethy/vim-illuminate',

    -- DB
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
            { 'tpope/vim-dadbod',                     lazy = true },
            { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
        }
    },

    -- Refactoring
    {
        'ThePrimeagen/refactoring.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-treesitter/nvim-treesitter' },
        }
    },

    -- Tests
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "rcasia/neotest-java",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "rouge8/neotest-rust",
            "haydenmeade/neotest-jest",
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
        --build = 'make install_jsregexp',
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
            -- { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim',    opts = {} },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        },
    },

    -- Add function signature floating while typing
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts) require 'lsp_signature'.setup(opts) end
    },

    -- Shows lsp status
    'nvim-lua/lsp-status.nvim',

    -- Navigate through lsp diagnostics
    {
        "folke/lsp-trouble.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
    },

    -- Inlay hints
    { "lvimuser/lsp-inlayhints.nvim" },

    -- Formatter
    {
        'stevearc/conform.nvim',
        opts = {},
    },

    -- Rust related plugins
    {
        'simrat39/rust-tools.nvim', -- annotates Rust file with return types etc
        dependencies = {
            { 'neovim/nvim-lspconfig' },
            { 'nvim-lua/plenary.nvim' },
        },
    },
    {
        'saecki/crates.nvim', -- crates management
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup()
        end,
    },

    -- Java related plugins
    {
        'mfussenegger/nvim-jdtls',
        dependencies = {
            { 'microsoft/vscode-java-test' },
            { 'microsoft/java-debug' },
        },
    },

    -- Latex related plugins
    'lervag/vimtex',

    -- Go related plugins
    {
        "ray-x/go.nvim",
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup()
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },


    -- Debugging
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter' }, -- needed
            { 'rcarriga/nvim-dap-ui' },            -- better ui
            { 'nvim-neotest/nvim-nio' },           --
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

    {
        'glacambre/firenvim',

        -- Lazy load firenvim
        -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
        cond = not not vim.g.started_by_firenvim,
        build = function()
            require("lazy").load({ plugins = "firenvim", wait = true })
            vim.fn["firenvim#install"](0)
        end
    },

}
return plugins
