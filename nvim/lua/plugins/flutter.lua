return {
  {
    "folke/snacks.nvim",
    init = function()
      vim.api.nvim_create_user_command("FlutterRun", function()
        local envs = { "Production", "Development", "Staging" }
        vim.ui.select(envs, {
          prompt = "Select Flutter Environment",
          format_item = function(item) return "Run " .. item end,
        }, function(choice)
          if choice then
            local cmd = "flutter run --dart-define=ENVIRONMENT=" .. choice:lower()
            Snacks.terminal(cmd, {
              win = { style = "float", position = "float" },
              interactive = true
            })
          end
        end)
      end, { desc = "Run Flutter with Environment Selection" })
    end,
  },
}
