return {
	"pocco81/auto-save.nvim",
	config = function()
		require("auto-save").setup({
			enabled = true, -- Start enabled
			execution_message = {
			  message = function() return "" end,
			  dim = 0.18, -- Dim the message so it's not distracting
			  cleaning_interval = 1, -- Clear message immediately
			},
			-- trigger_events = { "InsertLeave", "TextChanged" }, -- Save on these events

			-- Logic: Do not save if we are in a special buffer (like Neo-tree)
			condition = function(buf)
				local fn = vim.fn
				local utils = require("auto-save.utils.data")
				if
					fn.getbufvar(buf, "&modifiable") == 1
					and utils.not_in(fn.getbufvar(buf, "&filetype"), { "neo-tree", "TelescopePrompt" })
				then
					return true
				end
				return false
			end,

			write_all_buffers = false, -- Only save the file you are editing
			debounce_delay = 135, -- Wait 135ms after typing to save (prevents lag)
		})
	end,
}
