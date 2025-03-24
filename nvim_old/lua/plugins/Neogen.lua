return {
    "danymat/neogen",
    config = function()
        require("neogen").setup({
            enabled = true, -- Ativa o Neogen automaticamente
            languages = {
                c = {
                    template = {
                        annotation_convention = "doxygen", -- Usa Doxygen tanto para .c quanto .h
                    },
                },
		h = {
                    template = {
                        annotation_convention = "doxygen", -- Usa Doxygen tanto para .c quanto .h
                    },
                },
                cpp = {
                    template = {
                        annotation_convention = "doxygen", -- Inclui também para C++
                    },
                },
                -- Se estiver usando outras linguagens como C++, pode adicionar mais aqui.
            },
        })
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Neogen depende do Treesitter
    cmd = "Neogen", -- Carrega o plugin somente quando você usa o comando Neogen
}
