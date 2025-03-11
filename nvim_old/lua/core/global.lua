require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp" }, -- Certifique-se de que C está instalado
    highlight = {
        enable = true, -- Ativa o highlight baseado em treesitter
    },
    -- Mapeia arquivos .h como C
    filetype = {
        h = "c", -- Força o tratamento de arquivos .h como arquivos C
    },
})
