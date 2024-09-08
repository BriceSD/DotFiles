local java_cmds = vim.api.nvim_create_augroup('java_cmds', { clear = true })
local cache_vars = {}

-- Here you can add files/folders that you use at
-- the root of your project. `nvim-jdtls` will use
-- these to find the path to your project source code.
local root_files = {
    '.git',
    'pom.xml',

    --- here are more examples files that may or
    --- may not work as root files, according to some guy on the internet
    -- 'mvnw',
    -- 'gradlew',
    -- 'pom.xml',
    -- 'build.gradle',
}

local features = {
    -- change this to `true` to enable codelens
    codelens = true,

    -- change this to `true` if you have `nvim-dap`,
    -- `java-test` and `java-debug-adapter` installed
    debugger = true,
}

local function get_jdtls_paths()
    if cache_vars.paths then
        return cache_vars.paths
    end

    local path = {}

    path.data_dir = vim.fn.stdpath('cache') .. '/nvim-jdtls'

    local jdtls_install = require('mason-registry')
        .get_package('jdtls')
        :get_install_path()

    path.java_agent = jdtls_install .. '/lombok.jar'
    path.launcher_jar = vim.fn.glob(jdtls_install .. '/plugins/org.eclipse.equinox.launcher_*.jar')

    if vim.fn.has('mac') == 1 then
        path.platform_config = jdtls_install .. '/config_mac'
    elseif vim.fn.has('unix') == 1 then
        path.platform_config = jdtls_install .. '/config_linux'
    elseif vim.fn.has('win32') == 1 then
        path.platform_config = jdtls_install .. '/config_win'
    end

    path.bundles = {}

    ---
    -- Include java-test bundle if present
    ---
    local java_test_path = require('mason-registry')
        .get_package('java-test')
        :get_install_path()

    local java_test_bundle = vim.split(
        vim.fn.glob(java_test_path .. '/extension/server/*.jar'),
        '\n'
    )

    if java_test_bundle[1] ~= '' then
        vim.list_extend(path.bundles, java_test_bundle)
    end

    ---
    -- Include java-debug-adapter bundle if present
    ---
    local java_debug_path = require('mason-registry')
        .get_package('java-debug-adapter')
        :get_install_path()

    local java_debug_bundle = vim.split(
        vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'),
        '\n'
    )

    if java_debug_bundle[1] ~= '' then
        vim.list_extend(path.bundles, java_debug_bundle)
    end

    ---
    -- Useful if you're starting jdtls with a Java version that's
    -- different from the one the project uses.
    ---
    path.runtimes = {
        -- Note: the field `name` must be a valid `ExecutionEnvironment`,
        -- you can find the list here:
        -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        --
        -- This example assume you are using sdkman: https://sdkman.io
        -- {
        --   name = 'JavaSE-17',
        --   path = vim.fn.expand('~/.sdkman/candidates/java/17.0.6-tem'),
        -- },
        -- {
        --   name = 'JavaSE-18',
        --   path = vim.fn.expand('~/.sdkman/candidates/java/18.0.2-amzn'),
        -- },
        {
            name = 'JavaSE-21',
            path = vim.fn.expand('~/.sdkman/candidates/java/21.0.3-tem'),
        },
    }

    cache_vars.paths = path

    return path
end

local function enable_codelens(bufnr)
    pcall(vim.lsp.codelens.refresh)

    vim.api.nvim_create_autocmd('BufWritePost', {
        buffer = bufnr,
        group = java_cmds,
        desc = 'refresh codelens',
        callback = function()
            pcall(vim.lsp.codelens.refresh)
        end,
    })
end

local function enable_debugger(bufnr)
    require('jdtls').setup_dap({ hotcodereplace = 'auto' })
    require('jdtls.dap').setup_dap_main_class_configs()

    local opts = { buffer = bufnr }
    vim.keymap.set('n', '<leader>nr', "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)
    vim.keymap.set('n', '<leader>nt', "<cmd>lua require('jdtls').test_class()<cr>", opts)
    vim.keymap.set('n', '<leader>gt', "<cmd>lua require('jdtls').goto_subjects()<cr>", opts)
    vim.keymap.set('n', '<leader>gs', "<cmd>lua require('jdtls').super_implementation()<cr>", opts)
end

local function jdtls_on_attach(client, bufnr)
    if features.debugger then
        enable_debugger(bufnr)
    end

    if features.codelens then
        enable_codelens(bufnr)
    end

    -- The following mappings are based on the suggested usage of nvim-jdtls
    -- https://github.com/mfussenegger/nvim-jdtls#usage

    local opts = { buffer = bufnr }
    vim.keymap.set('n', '<leader>ri', "<cmd>lua require('jdtls').organize_imports()<cr>", opts)
    vim.keymap.set('n', '<leader>gt', "<cmd>lua require('jdtls.tests').goto_subjects()<cr>", opts)
    -- vim.keymap.set('n', '<leader>rv', "<cmd>lua require('jdtls').extract_variable()<cr>", opts)
    -- vim.keymap.set('x', '<leader>rv', "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
    -- vim.keymap.set('n', '<leader>rc', "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
    -- vim.keymap.set('x', '<leader>rc', "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
    -- vim.keymap.set('x', '<leader>rm', "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>", opts)
end

local function jdtls_setup(event)
    local jdtls = require('jdtls')

    local path = get_jdtls_paths()
    -- local data_dir = path.data_dir .. '/fut'
    local data_dir = path.data_dir .. '/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

    if cache_vars.capabilities == nil then
        jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

        local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
        cache_vars.capabilities = vim.tbl_deep_extend(
            'force',
            vim.lsp.protocol.make_client_capabilities(),
            ok_cmp and cmp_lsp.default_capabilities() or {}
        )
    end

    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    local cmd = {
        -- 💀
        'java',

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-javaagent:' .. path.java_agent,
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens',
        'java.base/java.util=ALL-UNNAMED',
        '--add-opens',
        'java.base/java.lang=ALL-UNNAMED',
        -- 💀
        '-jar',
        path.launcher_jar,

        -- 💀
        '-configuration',
        path.platform_config,

        -- 💀
        '-data',
        data_dir,
    }

    local m2_path = '/Users/brice/'
    local root_project = jdtls.setup.find_root(root_files)
    if root_project == nil then
        root_project = ''
    end
    if string.match(root_project, 'trpc%-french%-utilities') then
        m2_path = m2_path .. 'work/trpc-french-utilities/'
        root_project = '/Users/brice/work/trpc-french-utilities/'
    elseif string.match(root_project, 'primeo%-first') then
        m2_path = m2_path .. 'work/primeo-first/'
        root_project = '/Users/brice/work/primeo-first/'
    elseif string.match(root_project, 'papernest%-bird') then
        m2_path = m2_path .. 'work/papernest-bird/'
        root_project = '/Users/brice/work/papernest-bird/'
    elseif string.match(root_project, 'tmh%-v2g') then
        m2_path = m2_path .. 'work/tmh-v2g/'
        root_project = '/Users/brice/work/tmh-v2g/'
    end
    m2_path = m2_path .. '.m2/settings.xml'

    -- Set vim path to root project (see :find)
    -- TODO: only add gitfiles to path
    vim.opt.path = vim.opt.path + root_project + "/**"

    local lsp_settings = {
        java = {
            import = {
                gradle = {
                    enabled = true
                },
                maven = {
                    enabled = true
                },
                exclusions = {
                    "**/node_modules/**",
                    "**/.metadata/**",
                    "**/archetype-resources/**",
                    "**/META-INF/maven/**",
                    "/**/test/**"
                }
            },
            -- jdt = {
            --   ls = {
            --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
            --   }
            -- },
            cleanup = {
                actionsOnSave = {
                    'addFinalModifier',
                    'addOverride',
                },
            },
            symbols = {
                includeSourceMethodDeclarations = true,
            },
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                maven = { userSettings = m2_path, },
                updateBuildConfiguration = 'interactive',
                runtimes = path.runtimes,
            },
            maven = {
                downloadSources = true,
            },
            -- inlayHints = {
            --     parameterNames = {
            --         enabled = true, -- literals, all, none
            --     }
            -- },
            format = {
                enabled = true,
                settings = {
                    url = '/Users/brice/work/tripicaformat.xml',
                    profile = 'tripica',
                }
            },
            reference = {
                includeAccessors = true,
                -- no need to show references to libraries.
                includeDecompiledSources = true,
            },
            saveActions = {
                organizeImports = false,
            },
            referencesCodeLens = {
                enabled = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            signatureHelp = {
                enabled = true,
            },
            completion = {
                favoriteStaticMembers = {
                    'org.hamcrest.MatcherAssert.assertThat',
                    'org.hamcrest.Matchers.*',
                    'org.hamcrest.CoreMatchers.*',
                    'org.junit.jupiter.api.Assertions.*',
                    'java.util.Objects.requireNonNull',
                    'java.util.Objects.requireNonNullElse',
                    'org.mockito.Mockito.*',
                },
                importOrder = {
                    "java",
                    "javax",
                    "org",
                    "com",
                }
            },
            contentProvider = {
                preferred = 'fernflower',
            },
            extendedClientCapabilities = jdtls.extendedClientCapabilities,
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                }
            },
            codeGeneration = {
                toString = {
                    template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
                },
                useBlocks = true,
            },
        }
    }

    -- This starts a new client & server,
    -- or attaches to an existing client & server depending on the `root_dir`.
    jdtls.start_or_attach({
        cmd = cmd,
        settings = lsp_settings,
        on_attach = jdtls_on_attach,
        capabilities = cache_vars.capabilities,
        root_dir = root_project,
        --root_dir = jdtls.setup.find_root(root_files),
        flags = {
            allow_incremental_sync = true,
        },
        init_options = {
            bundles = path.bundles,
        },
    })
end

vim.api.nvim_create_autocmd('FileType', {
    group = java_cmds,
    pattern = { 'java' },
    desc = 'Setup jdtls',
    callback = jdtls_setup,
})
