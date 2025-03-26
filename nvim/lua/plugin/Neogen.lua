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
		h      = {
                    template = {
                        annotation_convention = "doxygen"
                    }
                }
            }
        })
        vim.api.nvim_set_keymap("n", "<leader>nd", ":Neogen<CR>", { noremap = true, silent = true })
    end
}

