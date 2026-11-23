----------------------------------------------------------------------
-- KOTLIN LSP (JetBrains kotlin-lsp) - ANDROID / GRADLE
-- ftplugin/kotlin.lua
----------------------------------------------------------------------

local bufnr = vim.api.nvim_get_current_buf()

----------------------------------------------------------------------
-- EXECUTABLE
----------------------------------------------------------------------

local server = vim.fn.exepath("kotlin-lsp")

if server == "" then
    local fallback = vim.fn.expand("~/.local/bin/kotlin-lsp")

    if vim.fn.executable(fallback) == 1 then
        server = fallback
    else
        vim.notify("Kotlin LSP não encontrado no PATH.", vim.log.levels.ERROR)
        return
    end
end

----------------------------------------------------------------------
-- JAVA (o kotlin-lsp precisa de JDK 17+)
----------------------------------------------------------------------

local java_home

for _, jdk in ipairs({
    "java-21-openjdk",
    "java-17-openjdk",
}) do
    local path = "/usr/lib/jvm/" .. jdk

    if vim.fn.isdirectory(path) == 1 then
        java_home = path
        break
    end
end

if not java_home then
    vim.notify("Nenhum JDK 17 ou 21 encontrado.", vim.log.levels.ERROR)
    return
end

----------------------------------------------------------------------
-- ROOT
-- Listas aninhadas = prioridade: primeiro procura settings.gradle em
-- toda a árvore (raiz do projeto multi-módulo), só depois os restantes.
----------------------------------------------------------------------

local root = vim.fs.root(bufnr, {
    { "settings.gradle", "settings.gradle.kts", "workspace.json" },
    { "build.gradle", "build.gradle.kts", "pom.xml", "gradlew" },
    { ".git" },
}) or vim.fn.getcwd()

----------------------------------------------------------------------
-- CAPABILITIES
----------------------------------------------------------------------

local capabilities = vim.lsp.protocol.make_client_capabilities()

local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

if has_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

----------------------------------------------------------------------
-- KEYMAPS
----------------------------------------------------------------------

local function on_attach(_, buf)
    local opts = { buffer = buf, silent = true }

    -- Organize imports (antes era um code_action genérico)
    vim.keymap.set("n", "<leader>oi", function()
        vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" }, diagnostics = {} },
            apply = true,
        })
    end, opts)

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

----------------------------------------------------------------------
-- START LSP
-- Sem bloco manual de "duplicate prevention": o vim.lsp.start já
-- reutiliza o cliente com o mesmo name + root_dir.
----------------------------------------------------------------------

vim.lsp.start({
    name = "kotlin-lsp",

    -- O Neovim comunica por stdio; --socket faria o servidor ficar
    -- à espera de uma ligação TCP que nunca chega.
    cmd = { server, "--stdio" },

    cmd_env = {
        JAVA_HOME = java_home,
        PATH = java_home .. "/bin:" .. vim.env.PATH,
    },

    root_dir = root,
    capabilities = capabilities,
    on_attach = on_attach,
}, {
    bufnr = bufnr,
})
