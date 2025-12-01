-- Enable system clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Indent Customisation
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

-- Leader Key
vim.g.mapleader = " "

-- Line Numbers
vim.opt.relativenumber = true

-- Diagnostics
vim.o.updatetime = 250
vim.diagnostic.config({
	virtual_text = false,
	float = { source = "always" },
})
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
	end,
})
