require("config.options")

local highlights = require("config.highlights")

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "dms",
    callback = function()
        vim.schedule(highlights.apply)
    end,
})
require("config.lazy")
require("config.keybinds")
require("config.diagnostics")



vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        vim.schedule(function()
            vim.cmd.colorscheme("dms")
            highlights.apply()
        end)
    end,
})


highlights.apply()

-- vim.o.winblend = 10
-- vim.o.pumblend = 10
