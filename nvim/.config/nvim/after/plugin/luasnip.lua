local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")




vim.keymap.set({ "i", "s" }, "<C-u>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })


vim.keymap.set({ "i", "s" }, "<C-z>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })


vim.keymap.set("i", "<C-l>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)
vim.keymap.set("n", "<leader>z", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")


-- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
local function bash(_, _, command)
    local file = io.popen(command, "r")
    local res = {}
    for line in file:lines() do
        table.insert(res, line)
    end
    return res
end

---Attempts to (in decreasing order of presedence):
-- - Convert a plural noun into a singular noun
-- - Return the first letter of the word
-- - Return "item" as a fallback
local function singular(input)
    local plural_word = input[1][1]
    local last_word = string.match(plural_word, '[_%w]*$')

    -- initialize with fallback
    local singular_word = 'item'

    if string.match(last_word, '.s$') then
        -- assume the given input is plural if it ends in s. This isn't always
        -- perfect, but it's pretty good
        singular_word = string.gsub(last_word, 's$', '', 1)
    elseif string.match(last_word, '^_?%w.+') then
        -- include an underscore in the match so that inputs like '_name' will
        -- become '_n' and not just '_'
        singular_word = string.match(last_word, '^_?.')
    end

    return s('{}', i(1, singular_word))
end



ls.add_snippets("rust", {
    s('derivedebug', t '#[derive(Debug)]'),
    s('deadcode', t '#[allow(dead_code)]'),
    s('allowfreedom', t '#![allow(clippy::disallowed_names, unused_variables, dead_code)]'),
    s('clippypedantic', t '#![warn(clippy::all, clippy::pedantic)]'),

    s(':turbofish', { t { '::<' }, i(0), t { '>' } }),

    s('print', {
        -- t {'println!("'}, i(1), t {' {:?}", '}, i(0), t {');'}}),
        t { 'println!("' }, i(1), t { ' {' }, i(0), t { ':?}");' } }),

    s('fori',
        {
            t { 'for ' }, i(2), t { ' in ' }, i(1), t { ' {', '' },
            t { '   ' }, i(0), t { '', '' },
            t { '}', '' },
            i(0),
        }),
    s('for',
        {
            t { 'for ' }, d(2, singular, { 1 }), t { ' in ' }, i(1), t { ' {', '' },
            t { '   ' }, i(3), t { '', '' },
            t { '}', '' },
            i(0),
        }),

    s('struct',
        {
            t { '#[derive(Debug)]', '' },
            t { 'struct ' }, i(1), t { ' {', '' },
            i(0),
            t { '}', '' },
        }),

    s('test',
        {
            t { '#[test]', '' },
            t { 'fn ' }, i(1), t { '() {', '' },
            t { '	assert' }, i(0), t { '', '' },
            t { '}' },
        }),

    s('testcfg',
        {
            t { '#[cfg(test)]', '' },
            t { 'mod ' }, i(1), t { ' {', '' },
            t { '   use super::*;', '' },
            t { '', '' },
            t { '	#[test]', '' },
            t { '	fn ' }, i(2), t { '() {', '' },
            t { '		assert' }, i(0), t { '', '' },
            t { '	}', '' },
            t { '}' },
        }),

    s('if',
        {
            t { 'if ' }, i(1), t { ' {', '' },
            t { '   ' }, i(2), t { '', '' },
            t { '}' },
            i(0),
        }),
})




ls.add_snippets("all", {
    s("ternary", {
        -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
        i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
    }),
    s({
        trig = "pwd",
        namr = "PWD",
        dscr = "Path to current working directory",
    }, {
        f(bash, {}, { user_args = { "pwd" } }),
    }),
})

ls.setup({
    history = true,
    -- Update more often, :h events for more info.
    update_events = "TextChanged,TextChangedI",
    -- Snippets aren't automatically removed if their text is deleted.
    -- `delete_check_events` determines on which events (:h events) a check for
    -- deleted snippets is performed.
    -- This can be especially useful when `history` is enabled.
    delete_check_events = "TextChanged",
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "choiceNode", "Comment" } },
            },
        },
    },
    -- treesitter-hl has 100, use something higher (default is 200).
    ext_base_prio = 300,
    -- minimal increase in priority.
    ext_prio_increase = 1,
    enable_autosnippets = true,
    -- mapping for cutting selected text so it's usable as SELECT_DEDENT,
    -- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
    -- store_selection_keys = "<Tab>",
})
