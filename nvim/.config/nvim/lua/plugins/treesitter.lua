return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
				highlight = {
					enable = true,
				},

				indent = {
					enable = true,
				},

				injections = {
					enable = true,
				},
			})

			local parsers = {
				"bash",
				"css",
				"fish",
				"gitignore",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"lua",
				"markdown",
				"python",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"xml",
				"yaml",
			}

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyDone",
				once = true,
				callback = function()
					require("nvim-treesitter").install(parsers)
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = "BufReadPost",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
				},
				move = {
					set_jumps = true,
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			max_lines = 3,
			min_window_height = 20,
		},
		keys = {
			{
				"[C",
				function()
					require("treesitter-context").go_to_context()
				end,
				desc = "go to context",
			},
		},
	},
}
