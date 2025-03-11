-- Instalar Mason para gerenciar servidores LSP
-- Instalar e configurar o Mason
require("mason").setup()

-- Instalar e gerenciar servidores LSP com Mason-LSPConfig
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "tsserver", "pyright", "clangd", "rust_analyzer" }, -- Servidores desejados
  automatic_installation = true, -- Instala automaticamente os servidores
})

-- Configuração do Mason-LSPConfig para rodar corretamente
require("mason-lspconfig").setup_handlers({
  function(server_name) -- Configuração padrão para todos os servidores
    require("lspconfig")[server_name].setup({})
  end,
  
  -- Configuração personalizada para cada LSP
  ["lua_ls"] = function()
    require("lspconfig").lua_ls.setup({
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } }, -- Evita erro ao usar 'vim'
        },
      },
    })
  end,

  ["tsserver"] = function()
    require("lspconfig").tsserver.setup({
      settings = {
        completions = { completeFunctionCalls = true },
      },
    })
  end,
})

-- Diagnósticos: Mostrar erro na frente da linha
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  float = { border = 'rounded' },
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})

print("LSP Configurado com sucesso!")

