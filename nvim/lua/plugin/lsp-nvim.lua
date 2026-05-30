return {
	----------------------------------------------------------------------
	-- MASON (LSP installer)
	----------------------------------------------------------------------
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		config = function()
			require("mason").setup()
		end,
	},

	----------------------------------------------------------------------
	-- LSP CONFIG
	----------------------------------------------------------------------
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},

		config = function()
			local lspconfig = require("lspconfig")

			------------------------------------------------------------------
			-- ON ATTACH
			------------------------------------------------------------------
			local on_attach = function(_, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }
				local keymap = vim.keymap.set

				keymap("n", "gd", vim.lsp.buf.definition, opts)
				keymap("n", "K", vim.lsp.buf.hover, opts)
				keymap("n", "gr", vim.lsp.buf.references, opts)
				keymap("n", "rn", vim.lsp.buf.rename, opts)
				keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				keymap("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end

			------------------------------------------------------------------
			-- CAPABILITIES (CMP)
			------------------------------------------------------------------
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			------------------------------------------------------------------
			-- MASON SETUP
			------------------------------------------------------------------
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"clangd",
					"lemminx",
					"angularls",
				},

				handlers = {
					----------------------------------------------------------------
					-- DEFAULT LSP HANDLER
					----------------------------------------------------------------
					function(server_name)
						lspconfig[server_name].setup({
							on_attach = on_attach,
							capabilities = capabilities,
						})
					end,

					----------------------------------------------------------------
					-- LUA (FIX DO "vim is undefined")
					----------------------------------------------------------------
					["lua_ls"] = function()
						lspconfig.lua_ls.setup({
							on_attach = on_attach,
							capabilities = capabilities,
							settings = {
								Lua = {
									runtime = {
										version = "LuaJIT",
									},
									diagnostics = {
										globals = { "vim" },
									},
									workspace = {
										checkThirdParty = false,
										library = vim.api.nvim_get_runtime_file("", true),
									},
									telemetry = {
										enable = false,
									},
								},
							},
						})
					end,

					----------------------------------------------------------------
					-- ANGULAR LSP
					----------------------------------------------------------------
					["angularls"] = function()
						lspconfig.angularls.setup({
							on_attach = on_attach,
							capabilities = capabilities,
							filetypes = {
								"typescript",
								"html",
								"typescriptreact",
								"htmlangular",
							},
						})
					end,

					----------------------------------------------------------------
					-- ARDUINO (OPCIONAL)
					----------------------------------------------------------------
					["arduino_language_server"] = function()
						lspconfig.arduino_language_server.setup({
							on_attach = on_attach,
							capabilities = capabilities,
							cmd = {
								vim.fn.expand("~/go/bin/arduino-language-server"),
								"-fqbn",
								"arduino:avr:uno",
								"-cli",
								"/usr/bin/arduino-cli",
								"-clangd",
								"/usr/bin/clangd",
							},
						})
					end,
				},
			})
		end,
	},

	----------------------------------------------------------------------
	-- CMP (AUTOCOMPLETE)
	----------------------------------------------------------------------
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},

		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noinsert",
				},

				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
}
