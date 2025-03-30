-- for http requests postman, insomnia alternative
return {
  {
    "mistweaverco/kulala.nvim",
    keys = {
      {
        "<leader>Ra",
        "<cmd>lua require('kulala').set_selected_env()<cr>",
        desc = "Set selected request as current",
        ft = "http",
      },
    },
    opts = {
      {
        curl_path = "curl",
        additional_curl_options = {},
        grpcurl_path = "grpcurl",

        -- b = buffer, g = global
        environment_scope = "g",
        default_env = "test",
        -- enable reading vscode rest client environment variables
        vscode_rest_client_environmentvars = false,
        request_timeout = nil,
        halt_on_error = true,
        contenttypes = {
          ["application/json"] = {
            ft = "json",
            formatter = vim.fn.executable("jq") == 1 and { "jq", "." },
            pathresolver = function(...)
              return require("kulala.parser.jsonpath").parse(...)
            end,
          },
          ["application/xml"] = {
            ft = "xml",
            formatter = vim.fn.executable("xmllint") == 1 and { "xmllint", "--format", "-" },
            pathresolver = vim.fn.executable("xmllint") == 1 and { "xmllint", "--xpath", "{{path}}", "-" },
          },
          ["text/html"] = {
            ft = "html",
            formatter = vim.fn.executable("xmllint") == 1 and { "xmllint", "--format", "--html", "-" },
            pathresolver = nil,
          },
        },

        debug = false,

        ui = {
          display_mode = "split",
          split_direction = "vertical",
          -- default view: "body" or "headers" or "headers_body" or "verbose" or fun(response: Response)
          default_view = "headers_body",
          winbar = true,
          default_winbar_panes = { "body", "headers", "headers_body" },
          -- enable/disable variable info text
          -- this will show the variable name and value as float
          -- possible values: false, "float"
          show_variable_info_text = false,

          -- enable/disable request summary in the output window
          show_request_summary = true,

          -- scratchpad default contents
          scratchpad_default_contents = {
            "@MY_TOKEN_NAME=my_token_value",
            "",
            "# @name scratchpad",
            "POST https://httpbin.org/post HTTP/1.1",
            "accept: application/json",
            "content-type: application/json",
            "",
            "{",
            '  "foo": "bar"',
            "}",
          },
        },
      },
    },
  },
}
