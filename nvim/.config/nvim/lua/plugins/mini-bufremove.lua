return {
	"echasnovski/mini.bufremove",
	keys = {
		{
			"<leader>bd",
			function()
				require("mini.bufremove").delete(0)
			end,
			desc = "Delete buffer",
		},
	},
}
