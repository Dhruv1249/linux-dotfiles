return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim", -- Bridges Mason with none-ls
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		-- =========================
		-- Global toggle (OFF by default)
		-- =========================
		vim.g.format_on_save = false

		-- Toggle keymap
		vim.keymap.set("n", "<leader>tf", function()
			vim.g.format_on_save = not vim.g.format_on_save
			if vim.g.format_on_save then
				print("Format on save: ON")
			else
				print("Format on save: OFF")
			end
		end, { desc = "Toggle format on save" })

		-- Manual format keymap
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({
				filter = function(c)
					return c.name == "null-ls"
				end,
			})
		end, { desc = "Format buffer (null-ls)" })

		-- =========================
		-- 1. Setup Mason-Null-LS
		-- =========================
		require("mason-null-ls").setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"black",
				"isort",
				"pylint",
				"eslint_d",
			},
			automatic_installation = true,
		})

		-- =========================
		-- 2. Setup None-LS
		-- =========================
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			sources = {
				-- Formatters
				formatting.stylua,
				formatting.prettier,
				formatting.black,
				formatting.isort,

				-- Linters
				diagnostics.pylint,
				require("none-ls.diagnostics.eslint_d"),
			},

			-- =========================
			-- 3. Format on Save (Conditional)
			-- =========================
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							if not vim.g.format_on_save then
								return
							end
							vim.lsp.buf.format({
								bufnr = bufnr,
								-- Only use null-ls for formatting (prevents conflicts with tsserver etc.)
								filter = function(c)
									return c.name == "null-ls"
								end,
							})
						end,
					})
				end
			end,
		})
	end,
}
