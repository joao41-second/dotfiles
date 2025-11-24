return {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
        require("neogen").setup({
            enabled = true,
            languages = {
                c = {
                    template = {
                        annotation_convention = "doxygen"
                    }
                },
                h = {
                    template = {
                        annotation_convention = "doxygen"
                    }
                }
            }
        })
        -- usar API moderna
        vim.keymap.set("n", "<leader>nd", "<cmd>Neogen<CR>", { noremap = true, silent = true })
    end
}
