-- LaTeX editing: compile + view with zathura, forward/inverse search
return {
  'lervag/vimtex',
  tag = 'v2.18', -- newer versions require nvim >= 0.12.4; Fedora ships 0.11.6
  lazy = false, -- must load at startup, ftplugin-based lazy load breaks vimtex
  init = function()
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_compiler_method = 'latexmk'
    vim.g.vimtex_compiler_latexmk = {
      build_dir = '',
      options = {
        '-pdf',
        '-shell-escape',
        '-verbose',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
      },
    }
    vim.g.vimtex_quickfix_mode = 0
    vim.g.tex_flavor = 'latex'
  end,
}
