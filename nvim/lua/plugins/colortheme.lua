return {
  {
    'rebelot/kanagawa.nvim',
    name = 'kanagawa',
    lazy = false, -- load at startup
    priority = 1000, -- ensure it loads before other plugins
    config = function()
      require('kanagawa').setup {
        compile = false, -- enable compiling for performance (optional)
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true, -- set true if you want transparent background
        dimInactive = false,
        terminalColors = true,
        theme = 'wave', -- "wave", "dragon", or "lotus"
        background = { -- map background to theme
          dark = 'wave',
          light = 'lotus',
        },
      }

      -- load the colorscheme
      vim.cmd 'colorscheme kanagawa'
    end,
  },
}
