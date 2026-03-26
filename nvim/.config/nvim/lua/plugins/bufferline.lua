return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "BufReadPost",
	opts = {
		options = {
			close_command = function(n)
				require("mini.bufremove").delete(n)
			end,
			diagnostics = "nvim_lsp",
			themable = true,
			offsets = {
				{
					filetype = "neo-tree",
					text = "Explorer",
					highlight = "Directory",
					separator = true,
				},
			},
			separator_style = "thin",
			show_close_icon = false,
			show_buffer_close_icons = true,
			indicator = {
				style = "underline",
			},
		},
	},
	keys = {
		{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
		{ "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
		{ "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
	},
}
