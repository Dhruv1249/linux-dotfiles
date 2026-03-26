local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>s", ":ASToggle<CR>", {desc = "Toggle Auto Save"})
-- Toggle Relative Numbers
vim.keymap.set("n", "<leader>rl", function()
	-- Toggle the option (logic: if it's on, turn it off; if off, turn it on)
vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle Relative Numbers" })

vim.keymap.set({ "n", "v" }, "<Up>", "<nop>", { silent = true })
vim.keymap.set({ "n", "v" }, "<Down>", "<nop>", { silent = true })
vim.keymap.set({ "n", "v" }, "<Left>", "<nop>", { silent = true })
vim.keymap.set({ "n", "v" }, "<Right>", "<nop>", { silent = true })

-- Commenting with Ctrl+/
vim.keymap.set("n", "<C-/>", "gcc", { desc = "Toggle Comment", remap = true })
vim.keymap.set("v", "<C-/>", "gc", { desc = "Toggle Comment", remap = true })
vim.keymap.set("n", "<C-_>", "gcc", { desc = "Toggle Comment", remap = true })
vim.keymap.set("v", "<C-_>", "gc", { desc = "Toggle Comment", remap = true })

-- Close buffer
vim.keymap.set("n", "<C-w>", function()
	require("mini.bufremove").delete(0, false)
end, { desc = "Close buffer" })

-- Ctrl + A → Select All
vim.keymap.set("n", "<C-a>", "ggVG$", { desc = "Select all" })

-- Ctrl + C → Copy
vim.keymap.set("v", "<C-S-c>", '"+y', { desc = "Copy to clipboard" })

-- Ctrl + V → Paste
vim.keymap.set("n", "<C-S-v>", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("i", "<C-S-v>", '<C-r>+', { desc = "Paste in insert mode" })

vim.keymap.set("n", "<leader>md", ":RenderMarkdown toggle<CR>")
