return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = {
				"go",
				"python",
				"c",
                "nix",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"elixir",
				"heex",
				"javascript",
				"html",
			},
            auto_install = true,
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
