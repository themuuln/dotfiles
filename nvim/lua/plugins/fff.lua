return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    lazy = false,
    opts = {
      prompt = " ",
      title = "FFF",
      base_path = vim.fs.normalize(vim.uv.cwd() or vim.fn.getcwd()),
      layout = {
        prompt_position = "top",
        preview_position = "right",
      },
      preview = {
        line_numbers = false,
      },
      grep = {
        modes = { "plain", "fuzzy", "regex" },
      },
    },
    keys = {
      { "<leader>/", function() require("config.fff").live_grep_root() end, desc = "Grep (Root Dir)" },
      { "<leader><space>", function() require("config.fff").find_files_root() end, desc = "Find Files (Root Dir)" },
      { "<leader>fc", function() require("config.fff").find_config_files() end, desc = "Find Config File" },
      { "<leader>ff", function() require("config.fff").find_files_root() end, desc = "Find Files (Root Dir)" },
      { "<leader>fF", function() require("config.fff").find_files_cwd() end, desc = "Find Files (cwd)" },
      { "<leader>sg", function() require("config.fff").live_grep_root() end, desc = "Grep (Root Dir)" },
      { "<leader>sG", function() require("config.fff").live_grep_cwd() end, desc = "Grep (cwd)" },
      {
        "<leader>sw",
        function()
          require("config.fff").grep_query_root()
        end,
        mode = { "n", "x" },
        desc = "Visual selection or word (Root Dir)",
      },
      {
        "<leader>sW",
        function()
          require("config.fff").grep_query_cwd()
        end,
        mode = { "n", "x" },
        desc = "Visual selection or word (cwd)",
      },
    },
  },

  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>/", false },
      { "<leader><space>", false },
      { "<leader>fc", false },
      { "<leader>ff", false },
      { "<leader>fF", false },
      { "<leader>sg", false },
      { "<leader>sG", false },
      { "<leader>sw", false },
      { "<leader>sW", false },
    },
    opts = function(_, opts)
      local items = vim.tbl_get(opts, "dashboard", "preset", "keys")
      if not items then
        return
      end

      for _, item in ipairs(items) do
        if item.key == "f" then
          item.action = ":lua require('config.fff').find_files_root()"
        elseif item.key == "g" then
          item.action = ":lua require('config.fff').live_grep_root()"
        elseif item.key == "c" then
          item.action = ":lua require('config.fff').find_config_files()"
        end
      end
    end,
  },
}
