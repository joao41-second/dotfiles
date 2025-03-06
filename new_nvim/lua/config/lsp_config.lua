-- Instalar Mason para gerenciar servidores LSP
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "tsserver", "pyright", "clangd", "rust_analyzer" }, -- Servidores desejados
})

-- Configurar os servidores LSP
local lspconfig = require("lspconfig")

local servers = { "lua_ls", "tsserver", "pyright", "clangd", "rust_analyzer" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  })
end



print("LSP Configurado com sucesso!")

