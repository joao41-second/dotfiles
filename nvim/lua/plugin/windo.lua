return {
  -- Tema bonito (escolha um)
  { "catppuccin/nvim", name = "catppuccin" }, -- Um tema moderno e agradável
  { "folke/tokyonight.nvim" }, -- Tema inspirado no Tokyo Night
  { "EdenEast/nightfox.nvim" }, -- Outro tema escuro muito bonito

  -- Statusline estiloso
  { "nvim-lualine/lualine.nvim", dependencies = { "kyazdani42/nvim-web-devicons" } },

  -- Ícones bonitos
  { "kyazdani42/nvim-web-devicons" }, -- Ícones para arquivos e plugins

  -- Melhor interface para selecionar arquivos e comandos
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Dashboard inicial personalizado
  { "glepnir/dashboard-nvim" },

  -- Bufferline estiloso (abas superiores)
  { "akinsho/bufferline.nvim", dependencies = { "kyazdani42/nvim-web-devicons" } },

  -- Melhor aparência para listas, diagnósticos e mensagens
  { "folke/trouble.nvim", dependencies = { "kyazdani42/nvim-web-devicons" } },
}

