return {
  {
    "gennaro-tedesco/nvim-jqx",
    event = { "BufReadPost" },
    ft = { "json", "yaml" },
  },
  {
    "Owen-Dechow/nvim_json_graph_view",
    dependencies = {
      "Owen-Dechow/graph_view_yaml_parser",
    },
    opts = {
      round_units = false,
    },
  },
}
