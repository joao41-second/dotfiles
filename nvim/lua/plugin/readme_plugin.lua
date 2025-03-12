return {
  "iamcco/markdown-preview.nvim",
  build = function()
    local install_path = vim.fn.expand(vim.fn.stdpath("data") .. "/site/pack/packer/start/markdown-preview.nvim/app")
    vim.fn.system({ "yarn", "install" }, install_path)
  end,
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  ft = { "markdown" },
  keys = {
    {
      "<leader>mp",
      "<cmd>MarkdownPreviewToggle<cr> | lua print('Preview URL: http://localhost:8080')<cr>",
      desc = "Toggle Markdown Preview and print URL"
    },
    {
      "<leader>mc",
      "<cmd>MarkdownPreviewToggle<cr> | lua vim.fn.setreg('+', 'http://localhost:8080')<cr>",
      desc = "Toggle Markdown Preview and copy URL"
    },
  },
  config = function()
    vim.g.mkdp_auto_start = 1  -- Não iniciar automaticamente
    vim.g.mkdp_auto_close = 0  -- Fechar automaticamente ao sair do buffer
    vim.g.mkdp_refresh_slow = 0 -- Atualização rápida
    vim.g.mkdp_open_to_the_world = 1 -- Não expor servidor local
    vim.g.mkdp_browser = "firefox"  -- Usar navegador padrão
    vim.g.mkdp_theme = "light"  -- Tema claro por padrão
    vim.g.mkdp_filetypes = { "markdown" } -- Habilitar apenas para Markdown
  end,
}

