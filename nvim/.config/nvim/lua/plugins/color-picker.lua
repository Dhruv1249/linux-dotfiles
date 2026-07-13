return{
  "eero-lehtinen/oklch-color-picker.nvim",
  event = "VeryLazy",
  version = "*",
  keys = {
    {
      "<leader>cp",
      function() require("oklch-color-picker").pick_under_cursor() end,
      desc = "Color pick under cursor",
    },
  },
  ---@type oklch.Opts
  opts = {
      highlight = {
          enabled = true,
          style = "foreground+virtual_left",
          enabled_lsps = true,
      }
  },
}
