return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = {},
        -- config = function()
        --     vim.cmd([[colorscheme tokyonight]])
        -- end,
    },
    -- VS CODE DARK MODERN
    {
        "gmr458/vscode_modern_theme.nvim",
        lazy = false,
        -- config = function()
        --     require("vscode_modern").setup({
        --         cursorline = true,
        --         transparent_background = true,
        --         nvim_tree_darker = true,
        --     })
        --     vim.cmd.colorscheme("vscode_modern")
        -- end,
    },
    -- CATPPUCCIN
    {
    	"catppuccin/nvim",
    	name = "catppuccin",
    	priority = 2000,
    	config = function()
    		-- Theme
    		require("catppuccin").setup({
    			flavour = "mocha",
    			integrations = {
    				cmp = true,
    				gitsigns = true,
    				nvimtree = true,
    				treesitter = true,
    				notify = false,
    				mini = {
    					enabled = true,
    					indentscope_color = "",
    				},
    			},
    		})
    		vim.cmd.colorscheme("catppuccin")
    	end,
    },
}
