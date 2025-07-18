return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "caddy",
        "cmake",
        "dart",
        -- "comment", -- comments are slowing down TS bigtime, so disable for now
        "css",
        "devicetree",
        "gitcommit",
        "gitignore",
        "glsl",
        "go",
        "graphql",
        "http",
        "just",
        "kconfig",
        "meson",
        "ninja",
        "scss",
        "sql",
        "svelte",
        "vue",
        "wgsl",
      },
    },
  },
  { "fei6409/log-highlight.nvim", event = "BufRead *.log", opts = {} },
}
