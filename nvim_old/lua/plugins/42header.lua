return {
    "Diogo-ss/42-header.nvim",
    cmd = { "Stdheader" },
    keys = { "<F3>" },
    opts = {
        default_map = true, -- Mapeamento padrão para <F1> no modo normal.
        auto_update = true, -- Atualizar o header ao salvar.
        user = "jperpct", -- Seu usuário.
        mail = "jperpect@student.42porto.com", -- Seu e-mail.
        -- adicionar outras opções, se necessário.
    },
    config = function(_, opts)
        require("42header").setup(opts)

        -- Criando o comando :Header para fazer o mesmo que :Stdheader
        vim.api.nvim_create_user_command("STD", function()
            vim.cmd("Stdheader")
        end, { nargs = 0 })
    end,
}
