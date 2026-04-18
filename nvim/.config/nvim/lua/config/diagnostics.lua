vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

vim.api.nvim_create_autocmd("BufReadPre", {
	pattern = "*asm", -- or "*.ext"
	callback = function(args)
		vim.diagnostic.enable(false, { bufnr = args.buf })
	end,
})
vim.o.updatetime = 250

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function(args)
    if vim.bo[args.buf].filetype == "asm" then
			return
		end

		vim.diagnostic.open_float(nil, {
			focusable = false,
			border = "rounded",
			source = "always",
		})
	end,
})
