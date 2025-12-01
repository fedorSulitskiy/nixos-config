return {
	-- 1. Disable the Mason-related plugins
	{ "williamboman/mason.nvim", enabled = false },
	{ "williamboman/mason-lspconfig.nvim", enabled = false },
	{ "WhoIsSethDaniel/mason-tool-installer.nvim", enabled = false },

	-- 2. Minimal lspconfig setup
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		opts = {
			diagnostics = {
				virtual_text = true,
				signs = true,
				underline = true,
			},
		},
		config = function(_, opts)
			-- apply diagnostic look-and-feel
			vim.diagnostic.config(opts.diagnostics)

			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			local nixdSetup = {
				nixpkgs = {
					expr = "import <nixpkgs> { }",
				},
				formatting = {
					command = { "nixfmt" }, -- or nixfmt or nixpkgs-fmt
				},
			}

			local servers = { lua_ls = {}, gopls = {}, nixd = nixdSetup }

			for name, server_opts in pairs(servers) do
				server_opts.capabilities = capabilities
				lspconfig[name].setup(server_opts)
			end
		end,
	},
}
