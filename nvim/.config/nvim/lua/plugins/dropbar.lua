return {
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",

    opts = {},

    config = function(_, opts)
      require("dropbar").setup(opts)

      local api = require("dropbar.api")

      vim.keymap.set("n", "<Leader>;", api.pick, {
        desc = "Pick symbols in winbar",
      })

      vim.keymap.set("n", "[;", api.goto_context_start, {
        desc = "Go to start of current context",
      })

      vim.keymap.set("n", "];", api.select_next_context, {
        desc = "Select next context",
      })
    end,
  },
}
