local M = {}

function M.apply()
    local hl = vim.api.nvim_set_hl
    local get = function(name)
        return vim.api.nvim_get_hl(0, { name = name, link = false })
    end

    local normal = get("Normal")
    local normal_float = get("NormalFloat")
    local pmenu = get("Pmenu")
    local pmenu_sel = get("PmenuSel")

    -- True primary accent, read live every time apply() runs (on colorscheme
    -- reload and on VeryLazy). `Statement`/keyword coloring is proven (see
    -- your own local/require keywords) to track the active DMS theme
    -- correctly at runtime — unlike a hardcoded hex, this one actually
    -- changes when you switch themes. Only `fg` is set anywhere below; no
    -- `bg` changes.
    local accent = get("Statement").fg

    ------------------------------------------------------------------
    -- Neo-tree
    ------------------------------------------------------------------

    hl(0, "NeoTreeNormal", {
        fg = normal.fg,
        bg = normal.bg,
    })

    hl(0, "NeoTreeNormalNC", {
        fg = normal.fg,
        bg = normal.bg,
    })

    hl(0, "NeoTreeEndOfBuffer", {
        bg = normal.bg,
    })

    hl(0, "NeoTreeWinSeparator", {
        fg = normal.bg,
        bg = normal.bg,
    })

    hl(0, "NeoTreeVertSplit", {
        fg = normal.bg,
        bg = normal.bg,
    })

    hl(0, "NeoTreeDirectoryIcon", {
        fg = accent,
    })

    hl(0, "NeoTreeDirectoryName", {
        fg = accent,
    })

    hl(0, "NeoTreeRootName", {
        fg = accent,
        bold = true,
    })

    hl(0, "NeoTreeFileIcon", {
        fg = accent,
    })

    ------------------------------------------------------------------
    -- Floats
    ------------------------------------------------------------------

    hl(0, "NormalFloat", {
        fg = normal_float.fg,
        bg = normal_float.bg,
    })

    hl(0, "FloatBorder", {
        fg = accent,
        bg = normal_float.bg,
    })

    hl(0, "FloatTitle", {
        fg = accent,
        bg = normal_float.bg,
        bold = true,
    })

    ------------------------------------------------------------------
    -- CMP
    ------------------------------------------------------------------

    hl(0, "Pmenu", {
        fg = pmenu.fg,
        bg = pmenu.bg,
    })

    hl(0, "PmenuSel", {
        fg = pmenu_sel.fg,
        bg = pmenu_sel.bg,
        bold = true,
    })

    hl(0, "CmpItemAbbrMatch", {
        fg = accent,
        bold = true,
    })

    hl(0, "CmpItemAbbrMatchFuzzy", {
        fg = accent,
        bold = true,
    })

    ------------------------------------------------------------------
    -- Telescope
    ------------------------------------------------------------------

    hl(0, "TelescopeNormal", {
        bg = normal_float.bg,
    })

    hl(0, "TelescopeBorder", {
        fg = accent,
        bg = normal_float.bg,
    })

    hl(0, "TelescopePromptNormal", {
        bg = normal_float.bg,
    })

    hl(0, "TelescopePromptBorder", {
        fg = accent,
        bg = normal_float.bg,
    })

    hl(0, "TelescopeResultsNormal", {
        bg = normal_float.bg,
    })

    hl(0, "TelescopeResultsBorder", {
        fg = accent,
        bg = normal_float.bg,
    })

    hl(0, "TelescopePreviewNormal", {
        bg = normal_float.bg,
    })

    hl(0, "TelescopePreviewBorder", {
        fg = accent,
        bg = normal_float.bg,
    })

    hl(0, "TelescopeSelectionCaret", {
        fg = accent,
    })

    hl(0, "TelescopeMatching", {
        fg = accent,
        bold = true,
    })

    ------------------------------------------------------------------
    -- Noice
    ------------------------------------------------------------------

    hl(0, "NoiceCmdlinePopup", {
        bg = normal_float.bg,
    })

    hl(0, "NoiceCmdlinePopupBorder", {
        fg = accent,
        bg = normal_float.bg,
    })

    hl(0, "NoicePopup", {
        bg = normal_float.bg,
    })

    hl(0, "NoicePopupBorder", {
        fg = accent,
        bg = normal_float.bg,
    })

    hl(0, "NotifyBackground", {
        bg = normal_float.bg,
    })

    -- Noice routes vim.notify() through nvim-notify. The INFO level
    -- (the most common one, e.g. your "dms integration" reload popups)
    -- was falling back to a default blue instead of the live accent.
    -- WARN/ERROR are left alone since red/yellow there is intentional.
    hl(0, "NotifyINFOIcon", {
        fg = accent,
    })

    hl(0, "NotifyINFOTitle", {
        fg = accent,
    })

    hl(0, "NotifyINFOBorder", {
        fg = accent,
    })
end

return M
