require('kanagawa').setup({
    compile = true,   -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = true,    -- do not set background color
    dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    colors = {
        -- add/modify theme and palette colors
        palette = {},
        theme = {
            wave = {},
            lotus = {},
            dragon = {},
            all = {
            }
        },
    },
    -- overrides = function(colors) -- add/modify highlights
    --     return {}
    -- end,
    theme = "wave", -- Load "wave" theme when 'background' option is not set
    background = {
        -- map the value of 'background' option to a theme
        dark = "wave", -- try "dragon" !
        light = "lotus"
    },
    overrides = function(colors)
        local theme = colors.theme
        return {
            -- NormalFloat = { bg = "none" },
            -- FloatTitle = { bg = "none" },
            -- FloatBorder = { bg = "none" },
            -- MsgArea = vim.o.cmdheight == 0 and { link = 'StatusLine' } or { fg = "none" },
            -- CursorLineNr = { fg = theme.diag.warning, bg = theme.ui.bg_gutter, bold = true },
            --
            -- TelescopeNormal = { bg = theme.ui.bg_dim },
            -- TelescopeBorder = { fg = theme.ui.bg_dim, bg = theme.ui.bg_dim },
            -- TelescopeTitle = { fg = theme.ui.bg_light3, bold = true },
            --
            -- TelescopePromptNormal = { bg = theme.ui.bg_light0 },
            -- TelescopePromptBorder = { fg = theme.ui.bg_light0, bg = theme.ui.bg_light0 },
            --
            -- TelescopeResultsNormal = { bg = "#1a1a22" },
            -- TelescopeResultsBorder = { fg = "#1a1a22", bg = "#1a1a22" },
            --
            -- TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            -- TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim }
            -- LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            -- MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            -- Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
            -- PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            -- PmenuSbar = { bg = theme.ui.bg_m1 },
            -- PmenuThumb = { bg = theme.ui.bg_p2 },
            -- NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            -- SpellBad = { undercurl = true, underline = false, sp = colors.palette.oldWhite },
            -- LspInlayHint = { fg = theme.ui.special },
        }
    end,
})

-- setup must be called before loading
vim.cmd("colorscheme kanagawa")
vim.cmd('hi IlluminatedWordText guibg=NONE guifg=NONE gui=NONE')
--vim.cmd('hi IlluminatedWordText guibg=#49443C    guifg=NONE gui=NONE')
vim.cmd('hi IlluminatedWordRead guibg=#2c3732 guifg=NONE gui=NONE')
vim.cmd('hi IlluminatedWordWrite guibg=#3e2f32 guifg=NONE gui=NONE')
