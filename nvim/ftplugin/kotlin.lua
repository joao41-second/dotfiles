----------------------------------------------------------------------
-- KMP-LSP - KOTLIN / ANDROID / GRADLE
-- Neovim 0.11+
----------------------------------------------------------------------

local bufnr = vim.api.nvim_get_current_buf()

-- Root markers
local root_markers = {
    "settings.gradle",
    "settings.gradle.kts",
    "build.gradle",
    "build.gradle.kts",
    "gradlew",
    "gradle.properties",
    "pom.xml",
    "build.xml",
    "Package.swift",
    ".git",
}

-- Executable
local server = vim.fn.exepath("kmp-lsp")

if server == "" then
    vim.notify("kmp-lsp not found in PATH", vim.log.levels.ERROR)
    return
end

-- Capabilities (nvim-cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()

local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

if has_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Project root
local root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

-- Keymaps
local function on_attach(_, buf)
    local opts = {
        buffer = buf,
        silent = true,
    }

    vim.keymap.set("n", "<leader>oi", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)

    vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({
            count = -1,
            float = true,
        })
    end, opts)

    vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({
            count = 1,
            float = true,
        })
    end, opts)
end

-- Start KMP-LSP
vim.lsp.start({
    name = "kmp-lsp",

    cmd = { server },

    root_dir = root,

    capabilities = capabilities,

    on_attach = on_attach,

    -- KMP-LSP uses its own workspace indexing.
    -- No JAVA_HOME or Gradle configuration required.
}, {
    bufnr = bufnr,
})
