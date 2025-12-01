return {
    {
        "folke/snacks.nvim",
        opts = {
            picker = {},
        },
        keys = {
            -- Search
            { "<leader>,",       function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
            { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
            { "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
            { "<leader><space>", function() Snacks.picker.files() end,                                   desc = "Find Files" },
            { "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
            -- Help
            { "<leader>sh",      function() Snacks.picker.help() end,                                    desc = "Help Pages" },
            { "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
            { "<leader>uC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
            { "<leader>qp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
            -- LSP
            { "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
            { "gr",              function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
            { "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
            { "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
            { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
        },
    }
}
