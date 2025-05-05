return {
  "epwalsh/pomo.nvim",
  version = "*",
  lazy = true,
  cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
  opts = {
    -- 10min
    update_interval = 600000,

    notifiers = {},

    timers = {
      Break = {
        { name = "System" },
      },
    },
    -- You can optionally define custom timer sessions.
    sessions = {
      work = {
        { name = "Work", duration = "25m" },
        { name = "Short Break", duration = "5m" },
        { name = "Work", duration = "25m" },
        { name = "Short Break", duration = "5m" },
        { name = "Work", duration = "25m" },
        { name = "Long Break", duration = "15m" },
      },
    },
  },
}
