require("mason").setup()
-- auto install dap
require("mason-nvim-dap").setup({
    ensure_installed = { "codelldb", }
})

-- require('mason-lspconfig').setup({
  -- ensure_installed = {'jdtls'},
  -- handlers = {
  --   -- this is the "custom handler" for `jdtls`
  --   -- noop is an empty function that doesn't do anything
  --   jdtls = lsp_zero.noop,
  --
  --   -- this first function is the "default handler"
  --   -- it applies to every language server without a "custom handler"
  --   function(server_name)
  --     if server_name ~= 'jdtls' then
  --         require('lspconfig')[server_name].setup({})
  --     end
  --   end,
  -- }
-- })

