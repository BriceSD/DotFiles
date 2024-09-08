local dap, dapui = require("dap"), require("dapui")
local widgets = require('dap.ui.widgets')
vim.keymap.set('n', '<F7>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F8>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F10>', function() require('dap').continue() end)
vim.keymap.set('n', '<F9>', function() require('dap').step_out() end)
vim.keymap.set('n', '<F12>', function() require('dap').terminate() end)
vim.keymap.set('n', '<Leader>bp', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B',
    function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
vim.keymap.set('n', '<Leader>bl',
    function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dbr', function() require('dap').repl.open() end, { desc = "[D]ebugger open [r]epl" })
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end, { desc = "[D]ebug [r]un last" })

vim.keymap.set({ 'n', 'v' }, '<Leader>dbe', function() require('dapui').eval() end, { desc = "[D]ebugger open [e]val" })
vim.keymap.set({ 'n', 'v' }, '<Leader>dbh', function() widgets.hover() end, { desc = "[D]ebugger [h]over" })
vim.keymap.set({ 'n', 'v' }, '<Leader>dbp', function() widgets.preview() end, { desc = "[D]ebugger open [p]review" })
vim.keymap.set('n', '<Leader>dbf', function() widgets.centered_float(widgets.frames) end, { desc = "[D]ebugger open [f]rames" })
vim.keymap.set('n', '<Leader>dbs', function() widgets.centered_float(widgets.scopes) end, { desc = "[D]ebugger open [s]copes" })
vim.keymap.set('n', '<Leader>dbt', function() dapui.toggle()  end, { desc = "[D]ebugger ui [t]oggle" })

require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },

})

dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
        -- CHANGE THIS to your path!
        command = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb") or "", -- let Mason manage corelldb
        args = { "--port", "${port}" },
    }
}

dap.configurations.rust = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            vim.fn.jobstart('cargo build')
            local workspaceRoot = require("lspconfig").rust_analyzer.get_root_dir()
            local workspaceName = vim.fn.fnamemodify(workspaceRoot, ":t")

            return vim.fn.input("Path to executable: ", workspaceRoot .. "/target/debug/" .. workspaceName, "file")
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}
dap.configurations.cpp = dap.configurations.rust
dap.configurations.c = dap.configurations.rust

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

require("nvim-dap-virtual-text").setup {
    enabled = true,                     -- enable this plugin (the default)
    enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true,            -- show stop reason when stopped for exceptions
    commented = false,                  -- prefix virtual text with comment string
    only_first_definition = false,      -- only show virtual text at first definition (if there are multiple)
    all_references = true,              -- show virtual text on all all references of the variable (not only definitions)
    --- A callback that determines how a variable is displayed or whether it should be omitted
    --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
    --- @param buf number
    --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
    --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
    --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
    display_callback = function(variable, _buf, _stackframe, _node)
        return variable.name .. ' = ' .. variable.value
    end,

    -- experimental features:
    virt_text_pos = 'eol',  -- position of virtual text, see `:h nvim_buf_set_extmark()`
    all_frames = false,     -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false,     -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
    -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}

dapui.setup({
    controls = {
        element = "repl",
        enabled = true,
        icons = {
            disconnect = "",
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = ""
        }
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
        border = "single",
        mappings = {
            close = { "q", "<Esc>" }
        }
    },
    force_buffers = true,
    icons = {
        collapsed = "",
        current_frame = "",
        expanded = ""
    },
    layouts = { {
        elements = { {
            id = "stacks",
            size = 0.20
        }, {
            id = "breakpoints",
            size = 0.15
        }, {
            id = "repl",
            size = 0.15
        }, {
            id = "scopes",
            size = 0.35
        }, {
            id = "watches",
            size = 0.15
        } },
        position = "left",
        size = 80
    }, {
        elements = { {
            id = "console",
            size = 1
        }, },
        position = "bottom",
        size = 13
    },
    },
    mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t"
    },
    render = {
        indent = 1,
        max_value_lines = 100
    }
})
