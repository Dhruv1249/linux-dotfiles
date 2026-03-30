-- lua/config/options.lua
-- 1. Indentation (VS Code Style)
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Shift 2 spaces when tabbing
vim.opt.tabstop = 2 -- 1 tab == 2 spaces
vim.opt.smartindent = true -- Auto-indent new lines
vim.opt.autoindent = true
-- 2. UI Behavior
vim.opt.number = true -- Show line numbers
--vim.opt.relativenumber = true -- Show relative line numbers (optional, good for jumps)
vim.opt.signcolumn = "yes" -- Always show the sign column (prevents text shifting)
vim.opt.wrap = false -- Disable text wrapping (optional)

-- 3. Clipboard
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
-- Disable Swap Files (No more "ATTENTION" messages)
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Keep Undo history (Optional: saves undo history even after closing)
-- If you don't want this either, set it to false.
vim.opt.undofile = true

-- Highlighting for the treesitter
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- 4. Wrap settings
vim.opt.wrap = true
vim.opt.linebreak = true   -- wrap at word boundaries
vim.opt.breakindent = true -- indent wrapped lines nicely
vim.opt.showbreak = "↪ "   -- symbol for wrapped line
vim.opt.sidescrolloff = 8
vim.opt.scrolloff = 8 
