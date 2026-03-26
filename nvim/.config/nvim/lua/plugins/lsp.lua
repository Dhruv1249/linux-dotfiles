return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- 1. Setup Mason (The installer)
		require("mason").setup()

		-- 2. Setup standard LSP capabilities
		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		-- 3. Setup Mason-LSPConfig (The bridge)
		require("mason-lspconfig").setup({
			-- A list of servers to automatically install
			ensure_installed = {
				"lua_ls",
				"pyright",
				"ts_ls",
				"html",
				"cssls",
				"bashls",
				"jsonls",
				"qmlls",
				"yamlls",
			},

      automatic_installation = true,

			-- OLD: setup_handlers(...) -> REMOVED
			-- NEW: handlers = { ... } inside setup()
			handlers = {
				-- The default handler: setup every server with default settings
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,

				-- Specific overrides for Lua
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
			},
		})

		-- 4. Keybindings (Global LSP mappings)
		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP actions",
			callback = function(event)
				local opts = { buffer = event.buf }
        vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

				vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { buffer = event.buf, desc = "Hover info" })
				vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { buffer = event.buf, desc = "Go to definition" })
				vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { buffer = event.buf, desc = "Go to declaration" })
				vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { buffer = event.buf, desc = "Go to implementation" })
				vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { buffer = event.buf, desc = "Go to type definition" })
				vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { buffer = event.buf, desc = "Find references" })
				vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = event.buf, desc = "Rename symbol" })
				vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = event.buf, desc = "Code action" })
			end,
		})
	end,
}
