return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },  -- Lazy load when opening a file
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "lua",
      callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.expandtab = true
      end
    })
  end
}



