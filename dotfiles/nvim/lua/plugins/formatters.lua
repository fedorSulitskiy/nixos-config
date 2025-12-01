return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters = {
				-- Lua
				stylua = {
					command = "stylua",
					args = { "-" },
					stdin = true,
				},

				-- Go
				gofmt = {
					command = "gofmt",
					stdin = true,
				},
				goimports = {
					command = "goimports",
					stdin = true,
				},

				-- Python
				black = {
					command = "black",
					args = { "--quiet", "-" },
					stdin = true,
				},
				isort = {
					command = "isort",
					args = { "--quiet", "-" },
					stdin = true,
				},

				-- Nix
				alejandra = {
					command = "alejandra",
					args = { "--quiet" },
					stdin = true,
				},
			},

			formatters_by_ft = {
				lua = { "stylua" },
				go = { "gofmt", "goimports" },
				python = { "black", "isort" },
				nix = { "alejandra" },
			},

			-- Format on save
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = { "n", "v" }, -- n = normal mode & v = visual mode
				desc = "Format buffer",
			},
		},
	},
}
