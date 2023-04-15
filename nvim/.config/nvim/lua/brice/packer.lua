-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'


    use { -- fuzzy finder and more
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }



    use({
        -- theme
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            require("rose-pine").setup()
            vim.cmd('colorscheme rose-pine')
        end
    })

    use 'nvim-lualine/lualine.nvim' -- Fancier statusline
    use 'numToStr/Comment.nvim'     -- "gc" to comment visual regions/lines
    use 'lewis6991/gitsigns.nvim'

    -- Enable Comment.nvim
    require('Comment').setup()

    -- Gitsigns
    -- See `:help gitsigns.txt`
    require('gitsigns').setup {
        signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
        },
    }


    -- Tree Sitter
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('nvim-treesitter/playground') -- view AST of current file
    use("nvim-treesitter/nvim-treesitter-context")


    -- Navigation
    use('ThePrimeagen/harpoon') -- easy switch between 4 files by marking them

    -- Undo tree history
    use('mbbill/undotree')


    -- Browse filesystem in a tree
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        }
    }

    -- Git
    use('tpope/vim-fugitive')             -- git integration/wrapper
    use('ThePrimeagen/git-worktree.nvim') -- git worktree wrapper



    -- Refactoring
    use {
        "ThePrimeagen/refactoring.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" }
        }
    }





    -- plugins development LSP
    use "folke/neodev.nvim"


    -- snipets
    use({
        "hrsh7th/nvim-cmp",
        -- follow latest release.
        tag = "v<CurrentMajor>.*",
        -- install jsregexp (optional!:).
        --run = "make install_jsregexp",
        config = [[require('config.nvim-cmp')]],
        requires = {
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-omni",
        },
    })

    -- LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {
                -- Optional
                'williamboman/mason.nvim',
                run = function()
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
        }
    }
    use 'nvim-lua/lsp-status.nvim'

    -- Rust related plugins
    use {
        'simrat39/rust-tools.nvim', -- annotates Rust file with return types etc
        requires = {
            { 'neovim/nvim-lspconfig' },
            { "nvim-lua/plenary.nvim" },
        }
    }


    -- Debugging
    use {
        "mfussenegger/nvim-dap",
        requires = {
            { 'nvim-treesitter/nvim-treesitter' }, -- needed
            { "rcarriga/nvim-dap-ui" },            -- better ui
            { "theHamsta/nvim-dap-virtual-text" }, -- annotates file with debug info
            { 'nvim-telescope/telescope-dap.nvim' },
            { 'nvim-telescope/telescope.nvim' },   -- needed for telescope-dap
            { "jay-babu/mason-nvim-dap.nvim" },    -- ensure dap are installed through mason
            { 'mortepau/codicons.nvim' },          -- Debugger icons (font)
        }
    }


    use { -- help to tell next available keys
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }
end)
