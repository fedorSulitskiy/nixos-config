return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- 1. register the servers
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = { Lua = { workspace = { checkThirdParty = false } } },
			})

			vim.lsp.config("gopls", {
				capabilities = capabilities,
				settings = { gopls = { analyses = { unusedparams = true }, staticcheck = true } },
			})

			vim.lsp.config("pyright", {
				capabilities = capabilities,
				settings = {
					pyright = { autoImportCompletion = true },
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
						},
					},
				},
			})

			vim.lsp.config("nixd", { capabilities = capabilities })

			-- 2. enable them
			vim.lsp.enable({ "lua_ls", "gopls", "pyright", "nixd" })
		end,
	},
}
