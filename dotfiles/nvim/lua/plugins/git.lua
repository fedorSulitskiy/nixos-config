return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },
    {
        "tpope/vim-fugitive",
    },
    {
        "folke/snacks.nvim",
        ---@type snacks.Config
        opts = {
            lazygit = {
                -- your lazygit configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        }
    },
}
