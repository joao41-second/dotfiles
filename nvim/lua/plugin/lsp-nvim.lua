return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "clangd" }, -- Adicionamos clangd
      })

      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 2,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
      })

      -- Configuração de servidores LSP
      local servers = { "lua_ls", "pyright", "clangd" }
      for _, server in ipairs(servers) do
        lspconfig[server].setup({})
      end
    end,
  },
}

