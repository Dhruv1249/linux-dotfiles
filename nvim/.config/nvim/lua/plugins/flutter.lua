return {
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("flutter-tools").setup({

				ui = {
					border = "rounded",
					notification_style = "native",
				},

				decorations = {
					statusline = {
						app_version = true,
						device = true,
						project_config = true,
					},
				},

				debugger = { enabled = false },

				widget_guides = { enabled = true },

				closing_tags = {
					highlight = "Comment",
					prefix = "  󰄶 ",
					priority = 10,
					enabled = true,
				},

				dev_log = {
					enabled = true,
					notify_errors = true,
					open_cmd = "15split",
					focus_on_open = false,
				},

				dev_tools = {
					autostart = true,
					auto_open_browser = false,
				},

				outline = {
					open_cmd = "35vnew",
					auto_open = false,
				},

				lsp = {
					on_attach = function(client, bufnr)
						-- call your existing on_attach here if needed
							
						local map = function(k, v, desc)
							vim.keymap.set("n", k, v, { buffer = bufnr, desc = desc })
						end

						map("<leader>fr", "<cmd>FlutterRun<cr>", "Flutter Run")
						map("<leader>fq", "<cmd>FlutterQuit<cr>", "Flutter Quit")
						map("<leader>fR", "<cmd>FlutterRestart<cr>", "Flutter Restart")
						map("<leader>fh", "<cmd>FlutterReload<cr>", "Flutter Hot Reload")
						map("<leader>fd", "<cmd>FlutterDevices<cr>", "Flutter Devices")
						map("<leader>fe", "<cmd>FlutterEmulators<cr>", "Flutter Emulators")
						map("<leader>fo", "<cmd>FlutterOutlineToggle<cr>", "Flutter Outline")
						map("<leader>fv", "<cmd>FlutterVisualDebug<cr>", "Flutter Visual Debug")
						map("<leader>fL", "<cmd>FlutterLogToggle<cr>", "Flutter Log Toggle")
						map("<leader>fl", "<cmd>FlutterLogClear<cr>", "Flutter Log Clear")
						map("<leader>fs", "<cmd>FlutterSuper<cr>", "Flutter Go to Super")
						map("<leader>fa", "<cmd>FlutterReanalyze<cr>", "Flutter Reanalyze")
						map("<leader>fP", "<cmd>FlutterPubGet<cr>", "Flutter Pub Get")
						map("<leader>fu", "<cmd>FlutterPubUpgrade<cr>", "Flutter Pub Upgrade")
						map("<leader>ft", "<cmd>Telescope flutter commands<cr>", "Flutter Telescope")
						map("<leader>fi", "<cmd>FlutterInspectWidget<cr>", "Flutter Inspect Widget")
						map("<leader>fb", "<cmd>FlutterToggleBrightness<cr>", "Flutter Toggle Brightness")
						map("<leader>fT", "<cmd>FlutterChangeTargetPlatform<cr>", "Flutter Toggle Platform")
					end,

					capabilities = function(config)
						local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
						if ok then
							config = vim.tbl_deep_extend("force", config, cmp_lsp.default_capabilities())
						end
						return config
					end,

					settings = {
						showTodos = true,
						completeFunctionCalls = true,
						renameFilesWithClasses = "prompt",
						enableSnippets = true,
						enableCodeLens = true,
						updateImportsOnRename = true,
						analysisExcludedFolders = {
							vim.fn.expand("$HOME/.pub-cache"),
						},
					},
				},
			})

			require("telescope").load_extension("flutter")
		end,
	},
}
