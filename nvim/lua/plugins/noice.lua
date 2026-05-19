return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      views = {
        mini = {
          position = { row = -2, col = '100%' },
          align = 'message-right',
        },
      },
      routes = {
        {
          filter = { event = 'msg_show', kind = '', find = '%d+L, %d+B' },
          view = 'mini',
        },
        {
          filter = { event = 'notify' },
          view = 'mini',
        },
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      {
        'rcarriga/nvim-notify',
        opts = {
          top_down = false,
        },
      },
    },
  },
}
