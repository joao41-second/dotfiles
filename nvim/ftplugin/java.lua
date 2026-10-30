local jdtls = require("jdtls")

----------------------------------------------------------------------
-- LOMBOK
----------------------------------------------------------------------

local lombok_path = "/usr/lib/lombok-common/lombok.jar"

if vim.fn.filereadable(lombok_path) ~= 1 then
    lombok_path = nil
    vim.notify("Lombok não encontrado em /usr/lib/lombok-common/lombok.jar", vim.log.levels.ERROR)
end

----------------------------------------------------------------------
-- ROOT DIRECTORY
----------------------------------------------------------------------

local root_markers = {
    "pom.xml",
    "mvnw",
    "build.gradle",
    "build.gradle.kts",
    "gradlew",
    "settings.gradle",
    "settings.gradle.kts",
    ".git",
    ".classpath",
}

local root_dir = require("jdtls.setup").find_root(root_markers)

if not root_dir then
    root_dir = vim.fn.getcwd()
end

----------------------------------------------------------------------
-- WORKSPACE
----------------------------------------------------------------------

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")

if project_name == "" then
    project_name = "java-project"
end

local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

vim.fn.mkdir(workspace_dir, "p")

----------------------------------------------------------------------
-- CAPABILITIES
----------------------------------------------------------------------

local capabilities = vim.lsp.protocol.make_client_capabilities()

local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

if has_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

----------------------------------------------------------------------
-- JDTLS COMMAND
----------------------------------------------------------------------

local cmd = {
    "/usr/bin/jdtls",
    "-data",
    workspace_dir,
    "--jvm-arg=-Xms1g",
    "--jvm-arg=-Xmx2G",
}

if lombok_path then
    table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_path)
end

----------------------------------------------------------------------
-- JDTLS CONFIGURATION
----------------------------------------------------------------------

local config = {
    cmd = cmd,

    root_dir = root_dir,

    capabilities = capabilities,

    settings = {
        java = {
            format = {
                enabled = true,
            },

            saveActions = {
                organizeImports = false,
            },

            completion = {
                favoriteStaticMembers = {
                    "org.junit.Assert.*",
                    "org.junit.jupiter.api.Assertions.*",
                },

                guessMethodArguments = true,
            },

            configuration = {
                updateBuildConfiguration = "automatic",
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

            references = {
                includeDecompiledSources = true,
            },
        },
    },

    init_options = {
        bundles = {},
    },
}

----------------------------------------------------------------------
-- ON ATTACH
----------------------------------------------------------------------

config.on_attach = function(client, bufnr)
    local opts = {
        buffer = bufnr,
        silent = true,
    }

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

    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
end

----------------------------------------------------------------------
-- DIAGNOSTICS
----------------------------------------------------------------------

vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        spacing = 2,
    },

    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,

    float = {
        border = "rounded",
        source = true,
    },
})

----------------------------------------------------------------------
-- START JDTLS
----------------------------------------------------------------------

jdtls.start_or_attach(config)
