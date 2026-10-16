return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    explorer = {
      replace_netrw = true, -- Automatically opens Snacks Explorer for directories
    },
    picker = {
      sources = {
        explorer = {
          hidden = true, -- Show hidden/dotfiles by default (toggle anytime with 'H')
          ignored = false, -- Show gitignored files (toggle anytime with 'I')
          follow_file = true, -- Follow / highlight currently active buffer
          tree = true,
          watch = true, -- Auto-refresh when files change outside Neovim (libuv watcher)
          layout = {
            preset = "sidebar", -- Classic docked sidebar layout
            preview = false, -- Toggle live preview with 'P' inside the explorer
          },
        },
      },
    },
    image = { enabled = true }, -- Terminal image preview support
  },
  keys = {
    -- <leader>E: Toggle Snacks Explorer open/close
    {
      "<leader>E",
      function()
        Snacks.explorer()
      end,
      desc = "Toggle Snacks Explorer",
    },
    -- <leader>e: Switch focus between Explorer and Code
    {
      "<leader>e",
      function()
        local explorer = Snacks.picker.get({ source = "explorer" })[1]
        if vim.bo.filetype:match("^snacks_picker") or (explorer and explorer:is_focused()) then
          -- If currently in the explorer, jump back to the previous window (code)
          vim.cmd("wincmd p")
        elseif explorer then
          -- If explorer is already open, focus its window
          if explorer.list and explorer.list.win and explorer.list.win:valid() then
            explorer.list.win:focus()
          elseif explorer.input and explorer.input.win and explorer.input.win:valid() then
            explorer.input.win:focus()
          else
            Snacks.explorer()
          end
        else
          -- If not open yet, open and focus it
          Snacks.explorer()
        end
      end,
      desc = "Switch between Explorer and Code",
    },
  },
}
