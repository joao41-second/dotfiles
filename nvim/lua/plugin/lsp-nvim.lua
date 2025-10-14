
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, -- nomes de eventos devem ter letras maiúsculas
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp", -- integração do LSP com nvim-cmp
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      lspconfig.clangd.setup({
        capabilities = capabilities,
        on_attach = function(_, _)
          vim.diagnostic.config({
            virtual_text = {
              prefix = "●", -- ícone antes da mensagem de erro
              spacing = 2,
            },
          })
        end,
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- idem, evento em maiúscula
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip", -- o nome do repositório é case-sensitive
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}

