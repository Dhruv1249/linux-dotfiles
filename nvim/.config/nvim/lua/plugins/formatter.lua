return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local conform = require("conform")

		-- =========================
		-- Global toggle
		-- =========================
		vim.g.format_on_save = false

		vim.keymap.set("n", "<leader>tf", function()
			vim.g.format_on_save = not vim.g.format_on_save
			if vim.g.format_on_save then
				print("Format on save: ON")
			else
				print("Format on save: OFF")
			end
		end, { desc = "Toggle format on save" })

		-- =========================
		-- Manual format
		-- =========================
		vim.keymap.set("n", "<leader>f", function()
			conform.format({
				async = true,
				lsp_fallback = true, -- Had to turn it on for jdtls
			})
		end, { desc = "Format buffer" })

		-- =========================
		-- Conform setup
		-- =========================
		conform.setup({
			formatters_by_ft = {
				-- Lua
				lua = { "stylua" },

				-- Python
				python = { "isort", "black" },

				-- Web
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },

				-- Rust
				rust = { "rustfmt" },

				-- Shell
				sh = { "shfmt" },
				bash = { "shfmt" },

				-- Docker
				dockerfile = { "prettier" },

				-- Terraform
				terraform = { "terraform_fmt" },

				-- Toml
				toml = { "taplo" },

				-- Markdown
				markdown = { "prettier" },

				-- ASM
				asm = { "asmfmt" },
			},

			-- =========================
			-- Format on save
			-- =========================
			format_on_save = function(bufnr)
				if not vim.g.format_on_save then
					return
				end
				return {
					timeout_ms = 500,
					lsp_fallback = false,
				}
			end,
		})
	end,
}
