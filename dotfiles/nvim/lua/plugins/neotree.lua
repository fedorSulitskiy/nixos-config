return {
    {
        "nvim-tree/nvim-web-devicons",
        opts = {},
        config = function()
            require("nvim-web-devicons").setup({
                default = true,
            })
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
    },
}
