return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  lazy = false,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  init = function()
    vim.g.no_plugin_maps = true
  end,
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
        selection_modes = {
          ["@function.outer"] = "V",
          ["@parameter.outer"] = "v",
        },
        include_surrounding_whitespace = false,
      },
      move = {
        set_jumps = true,
      },
    })

    -- SELECT
    local select = require("nvim-treesitter-textobjects.select")
    local keymaps = {
      ["a="] = "@assignment.outer",
      ["i="] = "@assignment.inner",
      ["l="] = "@assignment.lhs",
      ["r="] = "@assignment.rhs",
      ["a:"] = "@property.outer",
      ["i:"] = "@property.inner",
      ["l:"] = "@property.lhs",
      ["r:"] = "@property.rhs",
      ["aa"] = "@parameter.outer",
      ["ia"] = "@parameter.inner",
      ["ai"] = "@conditional.outer",
      ["ii"] = "@conditional.inner",
      ["al"] = "@loop.outer",
      ["il"] = "@loop.inner",
      ["ac"] = "@call.outer",
      ["ic"] = "@call.inner",
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
    }
    for key, query in pairs(keymaps) do
      vim.keymap.set({ "x", "o" }, key, function()
        select.select_textobject(query, "textobjects")
      end, { desc = query })
    end

    -- MOVE
    local move = require("nvim-treesitter-textobjects.move")
    vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@call.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "]i", function() move.goto_next_start("@conditional.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "]l", function() move.goto_next_start("@loop.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "]s", function() move.goto_next_start("@local.scope", "locals") end)

    vim.keymap.set({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@call.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next_end("@class.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "]I", function() move.goto_next_end("@conditional.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "]L", function() move.goto_next_end("@loop.outer", "textobjects") end)

    vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@call.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[i", function() move.goto_previous_start("@conditional.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[l", function() move.goto_previous_start("@loop.outer", "textobjects") end)

    vim.keymap.set({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@call.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[I", function() move.goto_previous_end("@conditional.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[L", function() move.goto_previous_end("@loop.outer", "textobjects") end)

    -- SWAP
    local swap = require("nvim-treesitter-textobjects.swap")
    vim.keymap.set("n", "<leader>na", function() swap.swap_next("@parameter.inner") end, { desc = "Swap next parameter" })
    vim.keymap.set("n", "<leader>pa", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap prev parameter" })
    vim.keymap.set("n", "<leader>nm", function() swap.swap_next("@function.outer") end, { desc = "Swap next function" })
    vim.keymap.set("n", "<leader>pm", function() swap.swap_previous("@function.outer") end, { desc = "Swap prev function" })

    -- REPEATABLE MOVE
    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}