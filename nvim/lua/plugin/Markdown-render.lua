return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons", -- o checkhealth mostrou que você usa este
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        latex = { enabled = false },
    },
}
