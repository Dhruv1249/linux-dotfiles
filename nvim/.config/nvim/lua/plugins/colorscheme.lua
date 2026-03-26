return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true, -- let terminal show through

			styles = {
				sidebars = "transparent",
			},

			on_colors = function(colors)
				local dank_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
				local dank = {}
				local f = io.open(dank_path, "r")
				if f then
					for line in f:lines() do
						local key, hex = line:match("base(%x%x)%s*=%s*'#(%x+)'")
						if key and hex then
							dank["base" .. key] = "#" .. hex
						end
					end
					f:close()
				end

				if not vim.tbl_isempty(dank) then
					colors.bg = dank.base00
					colors.bg_dark = dank.base01
					colors.bg_float = dank.base01
					colors.bg_highlight = dank.base02
					colors.bg_popup = dank.base01
					colors.bg_sidebar = dank.base00
					colors.bg_statusline = dank.base01

					colors.fg = dank.base05
					colors.fg_dark = dank.base04
					colors.fg_float = dank.base05
					colors.fg_gutter = dank.base03
					colors.fg_sidebar = dank.base05

					colors.comment = dank.base03

					colors.blue = dank.base0D
					colors.blue0 = dank.base0D
					colors.blue1 = dank.base0D
					colors.blue2 = dank.base0D
					colors.blue5 = dank.base0D
					colors.blue6 = dank.base0D
					colors.blue7 = dank.base0D

					colors.cyan = dank.base0C
					colors.green = dank.base0B
					colors.green1 = dank.base0B
					colors.green2 = dank.base0B
					colors.magenta = dank.base0E
					colors.magenta2 = dank.base0E
					colors.orange = dank.base09
					colors.red = dank.base08
					colors.red1 = dank.base08
					colors.teal = dank.base0C
					colors.yellow = dank.base0A
					colors.purple = dank.base0E
				end
			end,

			on_highlights = function(hl, c)
				-- Float background (glassy)
				hl.NormalFloat = {
					bg = c.bg_dark,
				}

				-- Borders slightly brighter than background
				hl.FloatBorder = {
					fg = c.purple,
					bg = c.bg_dark,
				}

				-- CMP menu
				hl.Pmenu = {
					fg = c.fg,
					bg = c.bg_dark,
				}
				hl.PmenuSel = {
					fg = c.bg_dark,
					bg = c.purple,
				}

				hl.NeoTreeNormal = { bg = "NONE" }
				hl.NeoTreeNormalNC = { bg = "NONE" }
				hl.NeoTreeEndOfBuffer = { bg = "NONE" }
				hl.NeoTreeWinSeparator = { bg = "NONE" }
				hl.NeoTreeVertSplit = { bg = "NONE" }
			end,
		},

		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(
					current_file_path,
					{},
					vim.schedule_wrap(function()
						vim.defer_fn(function()
							-- Force a re-evaluation of the tokyonight config
							package.loaded["tokyonight"] = nil
							require("tokyonight").setup(opts)
							vim.cmd.colorscheme("tokyonight")
							print("Tokyonight updated with new dankcolors")
						end, 100)
					end)
				)
			end
		end,
	},
}
