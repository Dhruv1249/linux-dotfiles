return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    { "folke/snacks.nvim", opts = { image = { enabled = true } } },
  },
keys = {
    { "<leader>E", "<cmd>Neotree toggle<cr>", desc = "Explorer NeoTree" },
  },
  config = function()
    require("neo-tree").setup({

	close_if_last_window = true,
      -- 1. Visual Setting
      window = {
        width = 30,
        mappings = {
          ["<space>"] = "none", -- Disable space to avoid accidental toggles
        },
      },
      
      -- 2. Filesystem settings (The main view)
      filesystem = {
        follow_current_file = {
          enabled = true, -- Highlight the file you are currently editing
        },
        use_libuv_file_watcher = true, -- Auto-update when files change outside Neovim
        filtered_items = {
          visible = true, -- Show hidden files? (false = hide dotfiles)
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
	})
      -- 3. Open Neo-tree automatically when opening a file (not a directory)
    local arg = vim.fn.argv(0)
    if arg ~= "" and vim.fn.isdirectory(arg) == 0 then
      vim.cmd([[Neotree show]])
    end
    -- 4. Custom Keybinding: Toggle Focus (File <-> Tree)
    vim.keymap.set("n", "<leader>e", function()
      if vim.bo.filetype == "neo-tree" then
        -- If we are in the tree, jump back to the previous window (the file)
        vim.cmd("wincmd p")
      else
        -- If we are in the file, focus the tree
        vim.cmd("Neotree focus")
      end
    end, { desc = "Focus Explorer" })
    
  end,
}
