-- return{
--   "MeanderingProgrammer/render-markdown.nvim",
--   ft = { "markdown", "md" },
--   dependencies = {
--     "nvim-treesitter/nvim-treesitter",
--     "nvim-tree/nvim-web-devicons", -- optional but recommended
--   },
--   opts = {},
-- }
-- For `plugins/markview.lua` users.
return {
    "OXY2DEV/markview.nvim",
    lazy = false,

    preview = {
        icon_provider = "devicons", -- "mini" or "devicons"
    }
 
};
