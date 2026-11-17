----------------------------------------------------------------------
-- KOTLIN LANGUAGE SERVER - ANDROID / GRADLE (ftplugin)
----------------------------------------------------------------------

local root_markers = {
    "settings.gradle",
    "settings.gradle.kts",
    "build.gradle",
    "build.gradle.kts",
    "gradlew",
    "gradle.properties",
    "pom.xml",
    ".git",
}

local bufnr = vim.api.nvim_get_current_buf()

-- Executável
local server = vim.fn.exepath("kotlin-language-server")
if server == "" then
    vim.notify("kotlin-language-server not found in PATH", vim.log.levels.ERROR)
    return
end

-- JDK compatível (o servidor crasha com Java 27)
local java_home
for _, jdk in ipairs({ "java-21-openjdk", "java-17-openjdk" }) do
    local path = "/usr/lib/jvm/" .. jdk
    if vim.fn.isdirectory(path) == 1 then
        java_home = path
        break
    end
end
if not java_home then
    vim.notify("Nenhum JDK 17/21 encontrado em /usr/lib/jvm", vim.log.levels.ERROR)
    return
end

-- Capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Root e workspace
local root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
local project_name = vim.fn.fnamemodify(root, ":t")
if project_name == "" then
    project_name = "kotlin-project"
end
local workspace = vim.fn.stdpath("data") .. "/kotlin-workspace/" .. project_name
vim.fn.mkdir(workspace, "p")

-- Keymaps (apenas neste buffer)
local function on_attach(_, buf)
    local opts = { buffer = buf, silent = true }
    vim.keymap.set("n", "<leader>oi", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
    end, opts)
    vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
    end, opts)
end

vim.lsp.start({
    name = "kotlin-language-server",
    cmd = { server },
    cmd_env = {
        JAVA_HOME = java_home,
        PATH = java_home .. "/bin:" .. vim.env.PATH,
    },
    root_dir = root,
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = { storagePath = workspace },
}, { bufnr = bufnr })
