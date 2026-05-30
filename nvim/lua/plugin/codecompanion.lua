return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			adapters = {
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = {
								default = "codegemma:2b",
							},
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "ollama",
				},
				inline = {
					adapter = "ollama",
				},
			},
		})
	end,
}
