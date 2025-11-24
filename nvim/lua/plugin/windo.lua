return {
  -- Tema bonito (escolha um)
  { "catppuccin/nvim", name = "catppuccin" }, -- Um tema moderno e agradável
  { "folke/tokyonight.nvim" }, -- Tema inspirado no Tokyo Night
  { "EdenEast/nightfox.nvim" }, -- Outro tema escuro muito bonito

  -- Statusline estiloso
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Ícones bonitos
  { "nvim-tree/nvim-web-devicons" }, -- Ícones para arquivos e plugins

  -- Melhor interface para selecionar arquivos e comandos
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Dashboard inicial personalizado
  { "glepnir/dashboard-nvim" },
...
}
