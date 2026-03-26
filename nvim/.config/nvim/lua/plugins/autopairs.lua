return {
	-- 1. Ultimate Autopair: handles typing pairs + newline expansion
	{
		"altermo/ultimate-autopair.nvim",
		event = { "InsertEnter", "CmdlineEnter" },
		branch = "v0.6",
		opts = {},
	},

	-- 2. nvim-autopairs: ONLY for cmp integration (confirm adds ())

	-- 3. Treesitter autotag: only for auto-closing/renaming tags
	
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}
