require("config.options")

local highlights = require("config.highlights")

local function transparent()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
end

require("config.lazy")
require("config.keybinds")
require("config.diagnostics")

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "dms",
    callback = function()
        vim.schedule(function()
            highlights.apply()
            transparent()
        end)
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        vim.schedule(function()
            vim.cmd.colorscheme("dms")
            highlights.apply()
            transparent()
        end)
    end,
})
