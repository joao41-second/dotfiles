local jdtls = require("jdtls")

-- Lombok
local lombok_path = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/lombok.jar")

-- Detecta root do projeto
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)

-- Nome único do workspace por projeto
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- Capabilities (completion + LSP extras)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local config = {
	cmd = {
		vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls"), -- <- só isto muda
		"-data",
		workspace_dir,
		"--jvm-arg=-javaagent:" .. lombok_path,
		"--jvm-arg=-Xbootclasspath/a:" .. lombok_path,
		"--jvm-arg=-Xms1g",
		"--jvm-arg=-Xmx2G",
	},

	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),

	settings = {
		java = {
			format = {
				enabled = true,
			},
			saveActions = {
				organizeImports = true,
			},
			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.jupiter.api.Assertions.*",
				},
			},
			configuration = {
				annotationProcessing = {
					enabled = true,
				},
			},
			maven = {
				downloadSources = true,
			},
			eclipse = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
		},
	},

	init_options = {
		bundles = {},
	},

	capabilities = capabilities,
}

-- Java-specific on_attach
config.on_attach = function(client, bufnr)
	local opts = { buffer = bufnr, silent = true }

	vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, opts)
	vim.keymap.set("n", "<leader>ev", jdtls.extract_variable, opts)
	vim.keymap.set("v", "<leader>ev", function()
		jdtls.extract_variable(true)
	end, opts)

	vim.keymap.set("n", "<leader>ec", jdtls.extract_constant, opts)
	vim.keymap.set("v", "<leader>ec", function()
		jdtls.extract_constant(true)
	end, opts)

	vim.keymap.set("v", "<leader>em", function()
		jdtls.extract_method(true)
	end, opts)
end

-- UI/diagnostics melhores
vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 2 },
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
})

-- Inicia JDTLS
jdtls.start_or_attach(config)
